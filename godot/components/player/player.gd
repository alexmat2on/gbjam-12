extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _interactor = $Interactor

var current_interactible = null

const playerSpeed := 250
const jumpSpeed := 200
const gravity := 15

# Called when the node enters the scene tree for the first time.
func _ready():
	_interactor.connect("area_entered", self._on_interaction_area_entered)
	_interactor.connect("area_exited", self._on_interaction_area_exited)
	_animated_sprite.play("idle")

var attack_playing = false

func _physics_process(_delta):
	if is_instance_valid(current_interactible) && Input.is_action_just_pressed("start"):
		current_interactible.interact()
		
	var horizontal_direction := Input.get_axis("left", "right")
		
	if Input.is_action_pressed("up") and is_on_floor():
		SoundManager.play(SoundEffect.JUMP)
		velocity.y -= jumpSpeed
	else:
		velocity.y += gravity
	
	var animation = "idle"
	
	if horizontal_direction != 0:
		_animated_sprite.flip_h = horizontal_direction < 0
		animation = "walk"
	
	_animated_sprite.play(animation)
	velocity.x = horizontal_direction * playerSpeed
	
	move_and_slide()

func _on_interaction_area_entered(interactible: Area2D):
	print("interaction entered!")
	if interactible.get_parent() is Interactible2D:
		current_interactible = interactible.get_parent()
		current_interactible.on_interact_enter()

func _on_interaction_area_exited(interactible: Area2D):
	print("interaction exit!")
	if interactible.get_parent() == current_interactible:
		current_interactible.on_interact_exit()
		current_interactible = null
