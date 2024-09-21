extends Node2D

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _start_label: Label = $Label

var _started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_sprite.play()
	_wait_for_toggle_timer()

func _process(delta) -> void:
	if Input.is_action_pressed("start") and not _started:
		_started = true
		get_tree().change_scene_to_file("res://scenes/levels/campsite.tscn")

func _toggle_label() -> void:
	_start_label.visible = not _start_label.visible
	_wait_for_toggle_timer()

func _wait_for_toggle_timer() -> void:
	get_tree().create_timer(1).timeout.connect(_toggle_label)
