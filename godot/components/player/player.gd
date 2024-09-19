extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _interactor = $Interactor

const playerSpeed := 250
const jumpSpeed := 200
const gravity := 15

enum State {
	IDLE,
	MALLET,
	CLEAVER,
	FLAMETHROWER
}

var _current_interactible = null
var _current_state = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	_interactor.connect("area_entered", self._on_interaction_area_entered)
	_interactor.connect("area_exited", self._on_interaction_area_exited)
	_animated_sprite.animation_finished.connect(self._on_animation_finished)

func _physics_process(_delta):
	if is_instance_valid(_current_interactible) && Input.is_action_just_pressed("start"):
		_current_interactible.interact()
	
	# TODO - change to current weapon held in "A" slot
	if Input.is_action_pressed("button_a"):
		_current_state = State.MALLET
		
	match _current_state:
		State.IDLE:
			var horizontal_direction := Input.get_axis("left", "right")
			if Input.is_action_pressed("up") and is_on_floor():
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
			_animated_sprite.play("attack_cleaver")
		State.FLAMETHROWER:
			_animated_sprite.play("attack_flamethrower")
	
	move_and_slide()

func _on_interaction_area_entered(interactible: Area2D):
	print("interaction entered!")
	if interactible.get_parent() is Interactible2D:
		_current_interactible = interactible.get_parent()
		_current_interactible.on_interact_enter()

func _on_interaction_area_exited(interactible: Area2D):
	print("interaction exit!")
	if _current_interactible == interactible.get_parent():
		_current_interactible.on_interact_exit()
		_current_interactible = null

func _on_animation_finished():
	match _current_state:
		State.MALLET, State.CLEAVER, State.FLAMETHROWER:
			_current_state = State.IDLE
