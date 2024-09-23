extends CharacterBody2D
class_name Entity

enum State {
	IDLE,
	AGGRO
}

const MAX_FALL_SPEED = 800.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var spawner: Spawner = get_node_or_null("Spawner")
@onready var drop_spawner: Spawner = get_node_or_null("DropSpawner")
@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")

@export var health: Health
@export var idle_behavior: EntityBehavior
@export var aggro_behavior: EntityBehavior
@export var detection_area: Area2D
@export var undetection_area: Area2D
@export var has_gravity = true

@onready var _targeted_player: Player = null

var _current_state = State.IDLE
var _is_facing_right = true
var _is_ready_to_spawn = true

var _initial_spawn_point: Vector2

signal on_death(entity: Entity)

# Called when the node enters the scene tree for the first time.
func _ready():
	if detection_area != null:
		detection_area.body_entered.connect(self._on_player_detected)
	if undetection_area != null:
		undetection_area.body_exited.connect(self._on_player_undetected)
	if is_instance_valid(spawner):
		spawner.ready_to_spawn.connect(self.activate_spawner)
	health.health_zero.connect(self._on_death)
	
	if is_instance_valid(animated_sprite):
		animated_sprite.play("idle")
	
	get_tree().create_timer(0.01).timeout.connect(_initialize_spawn_point)

func _on_death(drop_items):
	# TODO: Play death animation
	if drop_items:
		drop_spawner.spawn()
	on_death.emit(self)
	queue_free()
	

func _physics_process(delta):
	if aggro_behavior != null && _current_state == State.AGGRO:
		aggro_behavior.apply_behavior(self, delta)
	elif idle_behavior != null:
		idle_behavior.apply_behavior(self, delta)
		
	move_and_slide()

func _on_player_detected(player):
	if is_instance_valid(aggro_behavior) && player != null && player is Player:
		if _current_state == State.IDLE:
			idle_behavior.reset_behavior()
		_targeted_player = player
		_current_state = State.AGGRO
		if is_instance_valid(spawner) && _is_ready_to_spawn:
			activate_spawner()

func _on_player_undetected(player):
	if is_instance_valid(idle_behavior) && player != null && player is Player && player == _targeted_player:
		if _current_state == State.AGGRO:
			aggro_behavior.reset_behavior()
		_current_state = State.IDLE
		_targeted_player = null

func activate_spawner():
	if (_current_state == State.AGGRO):
		spawner.spawn(spawner.direction if _is_facing_right else Vector2(-spawner.direction.x, spawner.direction.y))
		_is_ready_to_spawn = false
	else:
		_is_ready_to_spawn = true

func _initialize_spawn_point():
	_initial_spawn_point = global_position

func take_damage(hitbox: Hitbox2D, hurt_mod: Array[Enums.HurtModifier]):
	var damage_amt: int = hitbox.damage
		
	if hitbox.hit_mod.has(Enums.HitModifier.LIGHT) && hurt_mod.has(Enums.HurtModifier.TOUGH):
		damage_amt = 0 * hitbox.damage
	if hitbox.hit_mod.has(Enums.HitModifier.HEAVY) && hurt_mod.has(Enums.HurtModifier.FLYING):
		damage_amt = 0 * hitbox.damage
	if hitbox.hit_mod.has(Enums.HitModifier.HEAVY) && !hurt_mod.has(Enums.HurtModifier.FLYING):
		damage_amt = 2 * hitbox.damage
	
	var destroy_items_if_killed = hitbox.hit_mod.has(Enums.HitModifier.FIRE) && hurt_mod.has(Enums.HurtModifier.FRAGILE)
	
	health.remove_health(damage_amt, !destroy_items_if_killed)
