extends CharacterBody2D

@onready var animSprite = $AnimatedSprite2D;

var playerSpeed = 500;

# Called when the node enters the scene tree for the first time.
func _ready():
	animSprite.play("idle")

func _physics_process(_delta):
	var vertical_direction = Input.get_axis("up", "down")
	var horizontal_direction = Input.get_axis("left", "right")
	
	var animation = "idle"
	
	if vertical_direction > 0:
		animation = "walk_down"
	if vertical_direction < 0:
		animation = "walk_up"
	if horizontal_direction > 0:
		animation = "walk_right"
	if horizontal_direction < 0:
		animation = "walk_left"
	
	animSprite.play(animation)
	velocity.x = horizontal_direction * playerSpeed
	velocity.y = vertical_direction * playerSpeed
	
	move_and_slide()
