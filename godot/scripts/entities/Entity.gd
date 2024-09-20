extends CharacterBody2D
class_name Entity

enum State {
	IDLE,
	AGGRO
}

const MAX_FALL_SPEED = 800.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var spawner: Spawner = get_node_or_null("Spawner")

@export var idle_behavior: EntityBehavior
@export var aggro_behavior: EntityBehavior
@export var detection_area: Area2D
@export var undetection_area: Area2D
@export var has_gravity = true

@onready var _targeted_player: Player = null

var _current_state = State.IDLE
var _is_facing_right = true
var _is_ready_to_spawn = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if detection_area != null:
		detection_area.body_entered.connect(self._on_player_detected)
	if undetection_area != null:
		undetection_area.body_exited.connect(self._on_player_undetected)
	if is_instance_valid(spawner):
		spawner.ready_to_spawn.connect(self.activate_spawner)

func _physics_process(delta):
	if aggro_behavior != null && _current_state == State.AGGRO:
		aggro_behavior.apply_behavior(self, delta)
	elif idle_behavior != null:
		idle_behavior.apply_behavior(self, delta)
		
	move_and_slide()

func _on_player_detected(player):
	if player != null && player is Player:
		_targeted_player = player
		_current_state = State.AGGRO
		if is_instance_valid(spawner) && _is_ready_to_spawn:
			activate_spawner()

func _on_player_undetected(player):
	if player != null && player is Player && player == _targeted_player:
		_current_state = State.IDLE
		_targeted_player = null

func activate_spawner():
	if (_current_state == State.AGGRO):
		spawner.spawn(spawner.direction if _is_facing_right else Vector2(-spawner.direction.x, spawner.direction.y))
		_is_ready_to_spawn = false
	else:
		_is_ready_to_spawn = true
