class_name Health
extends Node

@export var max_health: int = 3;
var _health: int;

signal health_updated(new_health: int)

func _ready():
	_health = max_health;
	health_updated.emit(_health)

func get_health():
	return _health;

func add_health():
	_health = min(max_health, _health + 1)
	health_updated.emit(_health)

func remove_health():
	_health = max(0, _health - 1)
	health_updated.emit(_health)
