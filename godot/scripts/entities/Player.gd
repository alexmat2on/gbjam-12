extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _interactor = $Interactor
@onready var health: Health = $Health
@onready var cleaver_spawner: Spawner = $CleaverSpawner
@onready var fireball_spawner: Spawner = $FireballSpawner

const playerSpeed := 60
const jumpSpeed := -300
const MAX_FALL_SPEED = 400.0
const COYOTE_TIME = 0.08
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


enum State {
	IDLE,
	MALLET,
	CLEAVER,
	FLAMETHROWER
}

enum movement_type {
	ANY,
	AERIAL,
	NONE,
	UNCONTROLLED
}

var _current_interactable = null
var _current_state = State.IDLE

var _seconds_since_started_falling = 0

var _a_state = State.CLEAVER
var _b_state = State.MALLET
var _is_a_ready_to_spawn = true
var _is_b_ready_to_spawn = true

# { State: Spawner }
var _spawner_map: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	_interactor.connect("area_entered", self._on_interaction_area_entered)
	_interactor.connect("area_exited", self._on_interaction_area_exited)
	_animated_sprite.animation_finished.connect(self._on_animation_finished)
	
	health.connect("health_updated", self._on_health_updated)
	SignalBus.player_health_updated.emit(health.get_health())
	
	_spawner_map = {
		State.CLEAVER: cleaver_spawner,
		State.MALLET: cleaver_spawner, # TODO: actual mallet projectile spawner
		State.FLAMETHROWER: fireball_spawner
	}
	
	# TODO: set these when you select your weapons
	_spawner_map[_a_state].ready_to_spawn.connect(func(): _is_a_ready_to_spawn = true)
	_spawner_map[_b_state].ready_to_spawn.connect(func(): _is_b_ready_to_spawn = true)

func _physics_process(_delta):
	if is_instance_valid(_current_interactable) && Input.is_action_just_pressed("start"):
		_current_interactable.interact(self)
		
	match _current_state:
		State.IDLE:
			_physics_process_idle(_delta)
		State.MALLET:
			_physics_process_mallet(_delta)
		State.CLEAVER:
			_physics_process_cleaver(_delta)
		State.FLAMETHROWER:
			_physics_process_flamethrower(_delta)
	
	move_and_slide()

func _base_movement(delta, do_gravity = true, flip_on_back = true, movement = movement_type.ANY, speed_multiplier = 1):
	if is_on_floor():
		_seconds_since_started_falling = 0
	else:
		_seconds_since_started_falling += delta
	
	# Add the gravity
	if do_gravity && not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = minf(velocity.y, MAX_FALL_SPEED)

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction && (movement == movement_type.ANY || (movement == movement_type.AERIAL && not is_on_floor())):
		velocity.x = (1 if direction > 0 else -1) * playerSpeed * speed_multiplier
		
		if flip_on_back && ((is_facing_right() && direction < 0) || (!is_facing_right() && direction > 0)):
			scale.x = -1

	elif movement != movement_type.UNCONTROLLED:
		velocity.x = move_toward(velocity.x, 0, playerSpeed * speed_multiplier)

	return direction


func _physics_process_idle(delta):
	var direction = _base_movement(delta)
	if not is_on_floor() && velocity.y > 0:
		_animated_sprite.play("walk") # TODO: Fall animation
	elif is_on_floor() && direction:
		_animated_sprite.play("walk")
	elif is_on_floor():
		_animated_sprite.play("idle")
		
	# Handle jump
	if Input.is_action_just_pressed("up") and _seconds_since_started_falling <= COYOTE_TIME:
		velocity.y = jumpSpeed
		_animated_sprite.play("jump")
		SoundManager.play(Enums.SoundEffect.JUMP)
	
	# Handle tools
	if _is_a_ready_to_spawn && Input.is_action_pressed("button_a"):
		_start_tool(_a_state)
		
	elif _is_b_ready_to_spawn && Input.is_action_pressed("button_b"):
		_start_tool(_b_state)

func _start_tool(state: State):
	match state:
		State.CLEAVER:
			_start_cleaver()
		State.MALLET:
			_start_mallet()
		State.FLAMETHROWER:
			_start_flamethrower()
	
	_current_state = state

func _activate_tool():
	match _current_state:
		State.CLEAVER:
			_activate_cleaver()
		State.MALLET:
			_activate_mallet()
		State.FLAMETHROWER:
			_activate_flamethrower()

func _start_cleaver():
	_animated_sprite.play("atk_cleaver_start")
	
func _physics_process_cleaver(delta):
	_base_movement(delta, true, false, movement_type.ANY)
	
	# Handle jump
	if Input.is_action_just_pressed("up") and _seconds_since_started_falling <= COYOTE_TIME:
		velocity.y = jumpSpeed

func _activate_cleaver():
	cleaver_spawner.spawn(cleaver_spawner.direction if is_facing_right() else Vector2(-cleaver_spawner.direction.x, cleaver_spawner.direction.y))
	if _a_state == State.CLEAVER:
		_is_a_ready_to_spawn = false
	else:
		_is_b_ready_to_spawn = false
	_current_state = State.IDLE
	
func _start_mallet():
	_animated_sprite.play("atk_mallet_start")

func _physics_process_mallet(delta):
	_base_movement(delta, true, true, movement_type.ANY if _animated_sprite.animation.ends_with("_channel") else movement_type.AERIAL, 0.6)
	
	# Handle jump
	if Input.is_action_just_pressed("up") and _seconds_since_started_falling <= COYOTE_TIME:
		velocity.y = jumpSpeed * 0.6
	
	if _animated_sprite.animation.ends_with("_channel") && !Input.is_action_pressed("button_a" if _a_state == State.MALLET else "button_b"):
		# TODO: spawn mallet projectile here
		_animated_sprite.play("atk_mallet_end")
	
func _activate_mallet():
	_animated_sprite.play("atk_mallet_channel")

func _start_flamethrower():
	_animated_sprite.play("atk_ft_start")

func _physics_process_flamethrower(delta):
	_base_movement(delta, true, false, movement_type.ANY if _animated_sprite.animation.ends_with("_channel") else movement_type.AERIAL)
	
	# Handle jump
	if !_animated_sprite.animation.ends_with("_channel") && Input.is_action_just_pressed("up") and _seconds_since_started_falling <= COYOTE_TIME:
		velocity.y = jumpSpeed
	
	if Input.is_action_just_released("button_a" if _a_state == State.FLAMETHROWER else "button_b"):
		fireball_spawner.disable_auto_spawn()
		_animated_sprite.play("atk_ft_end")

func _activate_flamethrower():
	fireball_spawner.offset = Vector2(20 if is_facing_right() else -20, 0)
	fireball_spawner.direction = Vector2.RIGHT if is_facing_right() else Vector2.LEFT
	fireball_spawner.enable_auto_spawn()
	_animated_sprite.play("atk_ft_channel")

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
	print("last played anim: ", _animated_sprite.animation)
	if _animated_sprite.animation.ends_with("_start"):
		_activate_tool()
	elif _animated_sprite.animation.ends_with("_end"):
		_current_state = State.IDLE

func _on_health_updated(new_health):
	SignalBus.player_health_updated.emit(new_health)

func take_damage(hitbox: Hitbox2D):
	# TODO: also include damage type (light, heavy, fire)
	health.remove_health(hitbox.damage)

func is_facing_right():
	# godot is stupid
	return scale.y == 1
