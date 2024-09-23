extends Node

var _day: int = 2
var _orders: int = 0

var player_tool_a: Enums.Tool = Enums.Tool.NONE
var player_tool_b: Enums.Tool = Enums.Tool.NONE


func clear():
	_day = 0
	_orders = 0
	player_tool_a = Enums.Tool.NONE
	player_tool_b = Enums.Tool.NONE

func get_day() -> int:
	return _day

func next_day() -> void:
	_day += 1

func set_orders(orders: int) -> void:
	_orders = orders

func decrement_orders() -> void:
	if _orders > 0:
		_orders -= 1

func get_orders() -> int:
	return _orders
