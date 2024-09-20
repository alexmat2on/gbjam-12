extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _interactor = $Interactor
@onready var health = $Health

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

# Called when the node enters the scene tree for the first time.
func _ready():
	_interactor.connect("area_entered", self._on_interaction_area_entered)
	_interactor.connect("area_exited", self._on_interaction_area_exited)
	_animated_sprite.animation_finished.connect(self._on_animation_finished)
	
	health.connect("health_updated", self._on_health_updated)
	SignalBus.player_health_updated.emit(health.get_health())

func _physics_process(_delta):
	if is_instance_valid(_current_interactable) && Input.is_action_just_pressed("start"):
		_current_interactable.interact(self)
	
	# TODO - change to current weapon held in "A" slot
	if Input.is_action_pressed("button_a"):
		_current_state = State.MALLET
	
	# TODO - change to current weapon held in "B" slot
	if Input.is_action_pressed("button_b"):
		_current_state = State.FLAMETHROWER
		
	match _current_state:
		State.IDLE:
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
		State.MALLET:
			velocity.x = 0
			_animated_sprite.play("attack_mallet")
		State.CLEAVER:
			velocity.x = 0
			_animated_sprite.play("attack_cleaver")
		State.FLAMETHROWER:
			velocity.x = 0
			_animated_sprite.play("attack_flamethrower")
	
	move_and_slide()

func _on_interaction_area_entered(interactable: Area2D):
	print("interaction entered!")
	if interactable.get_parent() is Interactable2D:
		_current_interactable = interactable.get_parent()
		_current_interactable.on_interact_enter(self)

func _on_interaction_area_exited(interactable: Area2D):
	print("interaction exit!")
	if _current_interactable == interactable.get_parent():
		_current_interactable.on_interact_exit(self)
		_current_interactable = null

func _on_animation_finished():
	match _current_state:
		State.MALLET, State.CLEAVER, State.FLAMETHROWER:
			_current_state = State.IDLE

func _on_health_updated(new_health):
	Logger.log(["health updated!", new_health])
	SignalBus.player_health_updated.emit(new_health)
