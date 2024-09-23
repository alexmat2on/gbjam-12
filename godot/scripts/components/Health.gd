class_name Health
extends Node

var _max_health: int = 5
var _health: int

signal health_updated(new_health: int)
signal health_zero(drop_items: bool)

func _ready():
	if GlobalState.is_serve_mode():
		_max_health = 3
	else:
		_max_health = 5
	_health = GlobalState.carried_health
	health_updated.emit(_health)

func get_health():
	return _health;

func add_health(amount: int = 1):
	_health = min(_max_health, _health + amount)
	health_updated.emit(_health)

func remove_health(amount: int = 1, drop_item_on_death: bool = false):
	_health = max(0, _health - amount)
	health_updated.emit(_health)
	
	if (_health == 0):
		health_zero.emit(drop_item_on_death)
