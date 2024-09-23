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
var _first_foray = true
var _day: int = 0
var _orders: int = 0
var _game_state: GameState = GameState.SETUP
var pause_tick: bool = false

var player_tool_a: Enums.Tool = Enums.Tool.NONE
var player_tool_b: Enums.Tool = Enums.Tool.NONE

var _time_left: float = ROUND_TIME

var enter_serve_mode_menu: OptionMenu = load("res://resources/enter_serve_mode_menu.tres")


func clear():
	get_tree().node_added.connect(on_node_added)
	_game_state = GameState.SETUP
	Inventory.clear()
	carried_health = 5
	_first_foray = true
	pause_tick = false
	_day = 0
	_orders = 0
	player_tool_a = Enums.Tool.NONE
	player_tool_b = Enums.Tool.NONE
	
	_time_left = ROUND_TIME
	SignalBus.time_updated.emit(_time_left)
	
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
	if not self.pause_tick:
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
	match _game_state:
		GameState.GATHER:
			# TODO: switch global state to a scene and use the option menu handler
			enable_serve_mode()
			get_tree().change_scene_to_file("res://scenes/levels/campsite.tscn")

func _tick_time(delta):
	_time_left = max(0.0, _time_left - delta)
	SignalBus.time_updated.emit(_time_left)
	

func get_day() -> int:
	return _day

func next_day() -> void:
	_day += 1

func set_orders(orders: int) -> void:
	_orders = orders

func decrement_orders() -> void:
	if _orders > 0:
		_orders -= 1
	if _orders == 0:
		# end of serve phase
		self._time_left = ROUND_TIME
		self.pause_tick = true
		self.enable_gather_mode()

func get_orders() -> int:
	return _orders

func is_first_foray() -> bool:
	return _first_foray

func enable_day_increment() -> void:
	_first_foray = false

func enable_serve_mode() -> void:
	_game_state = GameState.SERVE

func enable_gather_mode() -> void:
	_game_state = GameState.GATHER

func is_gather_mode() -> bool:
	return _game_state == GameState.GATHER

func is_serve_mode() -> bool:
	return _game_state == GameState.SERVE
