extends Node2D
class_name Spawner


@export var spawn_object: PackedScene
@export var speed = 0.0
@export var direction = Vector2(0.0, 0.0)
@export var minCooldown = 1.0
@export var maxCooldown = 1.0
@export var auto_spawn = true

signal ready_to_spawn


# Called when the node enters the scene tree for the first time.
func _ready():
	if auto_spawn:
		ready_to_spawn.connect(spawn)
		spawn()


func spawn(override_direction: Vector2 = direction):
	print("spawning bone at ", override_direction)
	var spawn_instance = spawn_object.instantiate()
	get_tree().root.add_child(spawn_instance)
	if spawn_instance is RigidBody2D:
		spawn_instance.global_position = global_position
		spawn_instance.linear_velocity = speed * override_direction
	elif spawn_instance is CharacterBody2D:
		spawn_instance.global_position = global_position
		spawn_instance.velocity = speed * override_direction
	
	var timer = get_tree().create_timer(randf_range(minCooldown, maxCooldown))
	timer.timeout.connect(ready_to_spawn.emit)
	
