extends Node2D
class_name Spawner


@export var spawn_object: PackedScene
@export var speed = 0.0
@export var direction = Vector2(0.0, 0.0)
@export var degrees_of_error = 0.0
@export var offset = Vector2(0.0, 0.0)
@export var minCooldown = 1.0
@export var maxCooldown = 1.0
@export var auto_spawn = true
@export var max_spawns = 0

var _current_spawn_count = 0

signal ready_to_spawn


# Called when the node enters the scene tree for the first time.
func _ready():
	if auto_spawn:
		ready_to_spawn.connect(spawn)
		spawn()


func spawn(override_direction: Vector2 = direction, override_offset: Vector2 = offset):
	if max_spawns <= 0 || _current_spawn_count < max_spawns:
		var spawn_instance = spawn_object.instantiate()
		get_tree().current_scene.add_child(spawn_instance)
		if override_direction.x < 0:
			spawn_instance.scale.x = -1
		if spawn_instance is RigidBody2D:
			spawn_instance.global_position = global_position + override_offset
			spawn_instance.linear_velocity = (speed * override_direction).rotated(deg_to_rad(randf() * 2.0 * degrees_of_error - degrees_of_error))
		elif spawn_instance is CharacterBody2D:
			spawn_instance.global_position = global_position + override_offset
			spawn_instance.velocity = (speed * override_direction).rotated(deg_to_rad(randf() * 2.0 * degrees_of_error - degrees_of_error))
		
		if max_spawns > 0 && spawn_instance.has_signal("on_death"):
			_current_spawn_count += 1
			spawn_instance.on_death.connect(reduce_spawn_count)
			if _current_spawn_count >= max_spawns:
				return

		var timer = get_tree().create_timer(randf_range(minCooldown, maxCooldown))
		timer.timeout.connect(ready_to_spawn.emit)
	
	
func reduce_spawn_count(spawned):
	spawned.on_death.disconnect(reduce_spawn_count)
	_current_spawn_count -= 1
	if max_spawns - _current_spawn_count == 1:
		var timer = get_tree().create_timer(randf_range(minCooldown, maxCooldown))
		timer.timeout.connect(ready_to_spawn.emit) 
	

func enable_auto_spawn():
	auto_spawn = true
	ready_to_spawn.connect(spawn)
	spawn()

func disable_auto_spawn():
	ready_to_spawn.disconnect(spawn)
	auto_spawn = false
