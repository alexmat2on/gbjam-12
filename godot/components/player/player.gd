extends CharacterBody2D
class_name Player

@onready var animSprite = $AnimatedSprite2D
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _interactor = $Interactor2D

const playerSpeed := 250
const jumpSpeed := 200
const gravity := 15

# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play("idle")

func _physics_process(_delta):
	if _interactor.has_interaction() && Input.is_action_just_pressed("start"):
		PlayerVariables.remove_health()
		print("interactive start pressed!")
	
	var horizontal_direction := Input.get_axis("left", "right")
		
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y -= jumpSpeed
	else:
		velocity.y += gravity
	
	var animation = "idle"

	if horizontal_direction > 0:
		animation = "walk_right"
	if horizontal_direction < 0:
		animation = "walk_left"
	
	_animated_sprite.play(animation)
	velocity.x = horizontal_direction * playerSpeed
	
	move_and_slide()
