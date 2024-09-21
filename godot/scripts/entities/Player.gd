extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _interactor = $Interactor
@onready var health: Health = $Health
@onready var cleaver_spawner: Spawner = get_node_or_null("CleaverSpawner")
@onready var fireball_spawner: Spawner = get_node_or_null("FireballSpawner")

const playerSpeed := 60
const jumpSpeed := 250
const gravity := 15

enum State {
	IDLE,
	MALLET,
	CLEAVER,
	FLAMETHROWER
}

var _current_interactable = null
var _current_state = State.IDLE
var _is_facing_right = true

var _is_ready_to_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_interactor.connect("area_entered", self._on_interaction_area_entered)
	_interactor.connect("area_exited", self._on_interaction_area_exited)
	_animated_sprite.animation_finished.connect(self._on_animation_finished)
	
	health.connect("health_updated", self._on_health_updated)
	SignalBus.player_health_updated.emit(health.get_health())
	
	if is_instance_valid(cleaver_spawner):
		cleaver_spawner.ready_to_spawn.connect(self.activate_spawner)
	if is_instance_valid(fireball_spawner):
		fireball_spawner.ready_to_spawn.connect(self.activate_spawner)

func _physics_process(_delta):
	if is_instance_valid(_current_interactable) && Input.is_action_just_pressed("start"):
		_current_interactable.interact(self)
	
	# TODO - change to current weapon held in "A" slot
	if Input.is_action_pressed("button_a"):
		_current_state = State.CLEAVER
	
	# TODO - change to current weapon held in "B" slot
	if Input.is_action_pressed("button_b"):
		_current_state = State.FLAMETHROWER
		
	match _current_state:
		State.IDLE:
			_physics_process_idle()
		State.MALLET:
			_physics_process_mallet()
		State.CLEAVER:
			_physics_process_cleaver()
		State.FLAMETHROWER:
			_physics_process_flamethrower()
	
	move_and_slide()

func activate_spawner():
	match _current_state:
		State.CLEAVER:
			cleaver_spawner.spawn(cleaver_spawner.direction if _is_facing_right else Vector2(-cleaver_spawner.direction.x, cleaver_spawner.direction.y))
			_is_ready_to_spawn = false
		State.FLAMETHROWER:
			fireball_spawner.spawn(fireball_spawner.direction if _is_facing_right else Vector2(-fireball_spawner.direction.x, fireball_spawner.direction.y))
			_is_ready_to_spawn = false
		_:
			_is_ready_to_spawn = true

func _physics_process_idle():
	var horizontal_direction := Input.get_axis("left", "right")
	if Input.is_action_pressed("up") and is_on_floor():
		SoundManager.play(Enums.SoundEffect.JUMP)
		velocity.y -= jumpSpeed
	else:
		velocity.y += gravity
	
	var animation = "idle"
	
	if horizontal_direction != 0:
		_animated_sprite.flip_h = horizontal_direction < 0
		animation = "walk"
	
	_animated_sprite.play(animation)
	velocity.x = horizontal_direction * playerSpeed

func _physics_process_mallet():
	velocity.x = 0
	velocity.y += gravity
	
	_animated_sprite.play("atk_mallet")

func _physics_process_cleaver():
	velocity.x = 0
	velocity.y += gravity
	_animated_sprite.play("atk_cleaver")

func _physics_process_flamethrower():
	velocity.x = 0
	velocity.y += gravity
	
	if Input.is_action_just_released("button_b"):
		_current_state = State.IDLE
	
	_animated_sprite.play("atk_ft_loop")

func _on_interaction_area_entered(interactable: Area2D):
	print("interaction entered!")
	if _current_interactable == null && interactable.get_parent() is Interactable2D:
		_current_interactable = interactable.get_parent()
		_current_interactable.on_interact_enter(self)

func _on_interaction_area_exited(interactable: Area2D):
	print("interaction exit!")
	if _current_interactable == interactable.get_parent():
		_current_interactable.on_interact_exit(self)
		_current_interactable = null

func _on_animation_finished():
	if _current_state != State.IDLE:
		match _current_state:
			State.CLEAVER: 
				if is_instance_valid(cleaver_spawner) && _is_ready_to_spawn:
					activate_spawner()
			State.FLAMETHROWER:
				Logger.log(["helloo", fireball_spawner, _is_ready_to_spawn])
				if is_instance_valid(fireball_spawner) && _is_ready_to_spawn:
					activate_spawner()

		_current_state = State.IDLE

func _on_health_updated(new_health):
	SignalBus.player_health_updated.emit(new_health)

func take_damage(hitbox: Hitbox2D):
	# TODO: also include damage type (light, heavy, fire)
	health.remove_health(hitbox.damage)
