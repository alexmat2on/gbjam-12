class_name Health
extends Node

@export var max_health: int = 3;
@export var damage_tag: DamageTag;
var _health: int;

enum DamageTag {
	NORMAL,
	FRAGILE,
	TOUGH
}

signal health_updated(new_health: int)
signal health_zero()

func _ready():
	_health = max_health;
	health_updated.emit(_health)

func get_health():
	return _health;

func add_health(amount: int = 1):
	_health = min(max_health, _health + amount)
	health_updated.emit(_health)

func remove_health(amount: int = 1):
	_health = max(0, _health - amount)
	health_updated.emit(_health)
	
	if (_health == 0):
		health_zero.emit()
