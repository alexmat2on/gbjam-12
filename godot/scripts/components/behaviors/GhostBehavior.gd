extends EntityBehavior
class_name GhostBehavior

enum Phase {
	IDLE,
	DANCE,
	RUSH
}


@export var y_distance = 60
@export var danceSpeed = 100.0
@export var rushSpeed = 100.0
@export var max_dance_radius = 80
@export var min_dance_move_time = 1.0
@export var max_dance_move_time = 2.0
@export var min_dance_time = 6.0
@export var max_dance_time = 7.5

var _current_phase: Phase = Phase.IDLE
var _target_position: Vector2


func reset_behavior():
	_current_phase = Phase.IDLE

func apply_behavior(entity: Entity, delta: float):
	if !_is_facing_player(entity):
		entity.scale.x = -1
		entity._is_facing_right = !entity._is_facing_right
		
	if _current_phase == Phase.IDLE:
		_current_phase = Phase.DANCE
		# TODO: set timer to target player current pos then switch to rush mode, then switch to dance mode
		_set_target_position(entity)
		get_tree().create_timer(randf_range(min_dance_time, max_dance_time)).timeout.connect(func(): _rush_target(entity))
	
	if _current_phase == Phase.DANCE:
		var x_diff_to_target = _target_position.x - entity.global_position.x
		if entity.global_position.distance_to(_target_position) > 20:
			entity.velocity.x = (1 if x_diff_to_target > 0 else -1) * danceSpeed
		else:
			entity.velocity.x = 0
		var y_diff_to_target = _target_position.y - entity.global_position.y
		if entity.global_position.distance_to(_target_position) > 20:
			entity.velocity.y = (1 if y_diff_to_target > 0 else -1) * 0.25 * danceSpeed
		else:
			entity.velocity.y = 0
	elif _current_phase == Phase.RUSH:
		# TODO: set timer to switch to dance mode
		pass
	else:
		entity.velocity = Vector2.ZERO

func _is_facing_player(entity: Entity):
	return entity._is_facing_right && entity._targeted_player.global_position.x > entity.global_position.x || \
		   !entity._is_facing_right && entity._targeted_player.global_position.x <= entity.global_position.x

func _set_target_position(entity: Entity):
	if _current_phase == Phase.DANCE:
		var target_x_distance = randf_range(-max_dance_radius, max_dance_radius)
		_target_position = Vector2(entity._targeted_player.global_position.x + target_x_distance, entity._targeted_player.global_position.y - y_distance)
		get_tree().create_timer(randf_range(min_dance_move_time, max_dance_move_time)).timeout.connect(func(): _set_target_position(entity))

func _prepare_rush(entity: Entity):

		get_tree().create_timer(1).timeout.connect(func(): _rush_target(entity))

func _rush_target(entity: Entity):
	if _current_phase == Phase.DANCE:
		_current_phase = Phase.RUSH
		_target_position = entity._targeted_player.global_position
		var direction = (_target_position - entity.global_position).normalized()
		entity.velocity = rushSpeed * direction
		get_tree().create_timer(1).timeout.connect(func(): _current_phase = Phase.IDLE)
	
