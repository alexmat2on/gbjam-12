extends RigidBody2D
class_name Projectile

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var hitbox: Hitbox2D = get_node_or_null("Hitbox2D")
@onready var _animated_sprite2d: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")

@export var has_gravity = false
@export var rotational_speed = 0.0
@export var lifetime = 30.0
@export var has_piercing = false


func _ready():
	if is_instance_valid(_animated_sprite2d):
		_animated_sprite2d.play("default")
	body_entered.connect(self._on_collided_with_object)
	if is_instance_valid(hitbox):
		hitbox.hit_something.connect(self._on_collided_with_object)
	var lifetimer = get_tree().create_timer(lifetime)
	lifetimer.timeout.connect(queue_free)
	get_tree().create_timer(0.01).timeout.connect(_init_angular_velocity)

func _init_angular_velocity():
	angular_velocity = rotational_speed if linear_velocity.x > 0 else -rotational_speed

func _on_collided_with_object(body):
	if !has_piercing:
		queue_free()

func take_damage(amount):
	queue_free()
