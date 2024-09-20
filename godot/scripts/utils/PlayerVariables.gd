extends Node

var _max_health: int = 3;
var _health: int = 3;

func get_health():
	return _health;

func add_health():
	_health = min(_max_health, _health + 1)

func remove_health():
	_health = max(0, _health - 1)
