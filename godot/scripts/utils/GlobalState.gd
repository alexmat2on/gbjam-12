extends Node
class_name Global

enum GameState {
	SETUP,
	GATHER,
	SERVE
}

const gather_levels = [
	"graveyard"
]

const ROUND_TIME = 60.0

var carried_health = 5
var _day: int = 0
var _orders: int = 0
var _game_state: GameState = GameState.SETUP

var player_tool_a: Enums.Tool = Enums.Tool.NONE
var player_tool_b: Enums.Tool = Enums.Tool.NONE

var _time_left: float = ROUND_TIME

var enter_serve_mode_menu: OptionMenu = load("res://resources/enter_serve_mode_menu.tres")
var finish_serve_mode_menu: OptionMenu = load("res://resources/finish_serve_mode_menu.tres")

func clear(full_reset: bool = false):
	print("clearing: ", full_reset)
	_game_state = GameState.SETUP
	carried_health = 5

	_orders = 0
	player_tool_a = Enums.Tool.NONE
	player_tool_b = Enums.Tool.NONE
	get_tree().node_added.connect(on_node_added)
	
	_time_left = ROUND_TIME
	SignalBus.time_updated.emit(_time_left)
	
	if full_reset:
		Inventory.clear()
		_day = 0
	else:
		_day += 1
	
func on_node_added(node: Node):
	if _game_state != GameState.SETUP:
		print("not setup")
		return
	elif gather_levels.any(func(n): return n == node.name):
		get_tree().node_added.disconnect(on_node_added)
		_game_state = GameState.GATHER

func _physics_process(delta):
	match _game_state:
		GameState.GATHER:
			_gather_physics_process(delta)
		GameState.SERVE:
			_serve_physics_process(delta)

func _gather_physics_process(delta):
	_tick_time(delta)
	if _time_left <= 0:
		SignalBus.selected_option.connect(on_option_selected)
		SignalBus.opened_option_menu.emit(enter_serve_mode_menu, false)
		# TODO: switch global state to a scene and use the option menu handler

func _serve_physics_process(delta):
	pass

func on_option_selected(id):
	SoundManager.stop(Enums.SoundEffect.FLAMETHROWER)
	SignalBus.selected_option.disconnect(on_option_selected)
	# TODO: switch global state to a scene and use the option menu handler
	match _game_state:
		GameState.GATHER:
			_game_state = GameState.SERVE
			get_tree().change_scene_to_file("res://scenes/levels/campsite.tscn")
		GameState.SERVE:
			clear()
			get_tree().change_scene_to_file("res://scenes/levels/campsite.tscn")
			

func _tick_time(delta):
	_time_left = max(0.0, _time_left - delta)
	SignalBus.time_updated.emit(_time_left)
	

func get_day() -> int:
	return _day

func set_orders(orders: int) -> void:
	_orders = orders

func decrement_orders() -> void:
	if _orders > 0:
		_orders -= 1
	if _orders == 0:
		# end of serve phase
		get_tree().create_timer(1).timeout.connect(finish_serve_phase)

func finish_serve_phase():
	SignalBus.selected_option.connect(on_option_selected)
	SignalBus.opened_option_menu.emit(finish_serve_mode_menu, false)
	# TODO: switch global state to a scene and use the option menu handler

func get_orders() -> int:
	return _orders

func enable_gather_mode() -> void:
	_game_state = GameState.GATHER

func is_gather_mode() -> bool:
	return _game_state == GameState.GATHER

func is_serve_mode() -> bool:
	return _game_state == GameState.SERVE
