extends EntityBehavior
class_name PatrolBehavior


@export var speed = 100.0
@export var edge_detecting_x_distance = 8

func apply_behavior(entity: Entity, delta: float):
	# Add the gravity.
	if not entity.is_on_floor():
		entity.velocity.y += entity.gravity * delta
		entity.velocity.y = minf(entity.velocity.y, entity.MAX_FALL_SPEED)
		
	if entity.is_on_wall() || _is_near_edge(entity):
		scale.x = -1
		entity._is_facing_right = !entity._is_facing_right
		
	entity.velocity.x = (1 if entity._is_facing_right else -1) * speed
	
func _is_near_edge(entity: Entity):
	if edge_detecting_x_distance <= 0 || !entity.is_on_floor():
		return false
		
	var space_state = get_world_2d().direct_space_state
	var x_position = entity.global_position.x + (edge_detecting_x_distance if entity._is_facing_right else -edge_detecting_x_distance)
	var edge_raycast = PhysicsRayQueryParameters2D.create(Vector2(x_position, entity.global_position.y - 2), Vector2(x_position, entity.global_position.y + 2))
	var edge_result = space_state.intersect_ray(edge_raycast)
	
	return not edge_result