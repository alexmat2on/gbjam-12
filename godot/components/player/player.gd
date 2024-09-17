extends CharacterBody2D
class_name Player

@onready var animSprite = $AnimatedSprite2D;

const playerSpeed := 250;
const jumpSpeed := 200;
const gravity := 15;

# Called when the node enters the scene tree for the first time.
func _ready():
	animSprite.play("idle")

func _physics_process(_delta):
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
	
	animSprite.play(animation)
	velocity.x = horizontal_direction * playerSpeed
	
	move_and_slide()
