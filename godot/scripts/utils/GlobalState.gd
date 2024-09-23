extends Node

enum GameState {
	GATHER,
	SERVE
}

var _day: int = 0
var _orders: int = 0
var _game_state: GameState = GameState.GATHER

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

func enable_serve_mode() -> void:
	_game_state = GameState.SERVE

func enable_gather_mode() -> void:
	_game_state = GameState.GATHER

func is_gather_mode() -> bool:
	return _game_state == GameState.GATHER

func is_serve_mode() -> bool:
	return _game_state == GameState.SERVE
