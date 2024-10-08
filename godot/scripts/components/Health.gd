class_name Health
extends Node

@export var max_health: int = 5
var _health: int

signal health_updated(new_health: int)
signal health_zero(drop_items: bool)

func _ready():
	_health = max_health
	health_updated.emit(_health)

func get_health():
	return _health;

func set_health(health: int):
	_health = health

func add_health(amount: int = 1):
	_health = min(max_health, _health + amount)
	health_updated.emit(_health)

func remove_health(amount: int = 1, drop_item_on_death: bool = false):
	_health = max(0, _health - amount)
	health_updated.emit(_health)
	
	if (_health == 0):
		health_zero.emit(drop_item_on_death)
