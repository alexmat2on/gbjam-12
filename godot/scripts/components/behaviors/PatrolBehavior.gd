extends EntityBehavior
class_name PatrolBehavior

@onready var animated_sprite = get_parent().get_node_or_null("AnimatedSprite2D")

@export var speed = 100.0
@export var edge_detecting_x_distance = 8
@export var max_patrol_radius = 0

func reset_behavior():
	return

func apply_behavior(entity: Entity, delta: float):
	# Add the gravity.
	if entity.has_gravity && not entity.is_on_floor():
		entity.velocity.y += entity.gravity * delta
		entity.velocity.y = minf(entity.velocity.y, entity.MAX_FALL_SPEED)
		
	if entity.is_on_wall() || _is_near_edge(entity) || _walked_out_of_patrol_area(entity):
		entity.scale.x = -1
		entity._is_facing_right = !entity._is_facing_right

	if is_instance_valid(animated_sprite):
		animated_sprite.flip_h = true # I drew the default walk animation the wrong way... :facepalm:
		if speed > 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
		
	entity.velocity.x = (1 if entity._is_facing_right else -1) * speed
	
func _is_near_edge(entity: Entity):
	if edge_detecting_x_distance <= 0 || !entity.is_on_floor():
		return false
		
	var space_state = get_world_2d().direct_space_state
	var x_position = entity.global_position.x + (edge_detecting_x_distance if entity._is_facing_right else -edge_detecting_x_distance)
	var edge_raycast = PhysicsRayQueryParameters2D.create(Vector2(x_position, entity.global_position.y - 2), Vector2(x_position, entity.global_position.y + 2))
	var edge_result = space_state.intersect_ray(edge_raycast)
	
	return not edge_result

func _walked_out_of_patrol_area(entity: Entity):
	if max_patrol_radius <= 0 || entity.global_position.distance_to(entity._initial_spawn_point) <= max_patrol_radius:
		return false
	else:
		return (entity._is_facing_right && entity.global_position.x > entity._initial_spawn_point.x) || (!entity._is_facing_right && entity.global_position.x < entity._initial_spawn_point.x)
		
