extends CharacterBody2D
class_name Entity

enum State {
	IDLE,
	AGGRO
}

const MAX_FALL_SPEED = 800.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var idle_behavior: EntityBehavior
@export var aggro_behavior: EntityBehavior
@export var detection_area: Area2D
@export var has_gravity = true

var _current_state = State.IDLE
var _is_facing_right = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if detection_area != null:
		detection_area.area_entered.connect(_on_player_detected)
		detection_area.area_exited.connect(_on_player_undetected)

func _physics_process(delta):
	if aggro_behavior != null && _current_state == State.AGGRO:
		aggro_behavior.apply_behavior(self, delta)
	elif idle_behavior != null:
		idle_behavior.apply_behavior(self, delta)
		
	move_and_slide()

func _on_player_detected(player):
	if player != null && player is Player:
		_current_state = State.AGGRO

func _on_player_undetected(player):
	if player != null && player is Player:
		_current_state = State.IDLE
