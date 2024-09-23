extends EntityBehavior
class_name ChaseBehavior


@export var speed = 100.0
@export var edge_detecting_x_distance = 8
@export var jump_velocity = -200.0
@export var min_chase_distance = 0

@onready var animated_sprite = get_parent().get_node_or_null("AnimatedSprite2D")

func reset_behavior():
	return
	
func apply_behavior(entity: Entity, delta: float):
	# Add the gravity.
	if entity.has_gravity && not entity.is_on_floor():
		entity.velocity.y += entity.gravity * delta
		entity.velocity.y = minf(entity.velocity.y, entity.MAX_FALL_SPEED)
	
	if !_is_facing_player(entity):
		entity.scale.x = -1
		entity._is_facing_right = !entity._is_facing_right
	
	if min_chase_distance <= 0 || entity.global_position.distance_to(entity._targeted_player.global_position) > min_chase_distance:
		if jump_velocity < 0 && entity.is_on_floor() && (entity.is_on_wall() || _is_near_edge(entity)):
			entity.velocity.y = jump_velocity
			
		entity.velocity.x = (1 if entity._is_facing_right else -1) * speed
		
		if is_instance_valid(animated_sprite):
			animated_sprite.flip_h = true # I drew the default walk animation the wrong way... :facepalm:
			if speed > 0:
				animated_sprite.play("walk")
			else:
				animated_sprite.play("idle")
	else:
		entity.velocity.x = 0
	
func _is_near_edge(entity: Entity):
	if edge_detecting_x_distance <= 0 || !entity.is_on_floor():
		return false
		
	var space_state = get_world_2d().direct_space_state
	var x_position = entity.global_position.x + (edge_detecting_x_distance if entity._is_facing_right else -edge_detecting_x_distance)
	var edge_raycast = PhysicsRayQueryParameters2D.create(Vector2(x_position, entity.global_position.y - 2), Vector2(x_position, entity.global_position.y + 2))
	var edge_result = space_state.intersect_ray(edge_raycast)
	
	return not edge_result

func _is_facing_player(entity: Entity):
	return entity._is_facing_right && entity._targeted_player.global_position.x > entity.global_position.x || \
		   !entity._is_facing_right && entity._targeted_player.global_position.x <= entity.global_position.x
