extends Node

var _current_option_menu: OptionMenu
var _current_selection_index: int = 0
var _stay_paused_on_select: bool = false


func _ready():
	SignalBus.opened_option_menu.connect(_on_menu_opened)
	process_mode = ProcessMode.PROCESS_MODE_WHEN_PAUSED


func _on_menu_opened(option_menu: OptionMenu, stay_paused_on_select: bool):
	get_tree().paused = true
	_current_option_menu = option_menu
	_current_selection_index = 0
	_stay_paused_on_select = stay_paused_on_select
	_update_display()

func _process(delta):
	if Input.is_action_just_pressed("down"):
		_current_selection_index = (_current_selection_index + 1) % _current_option_menu.options.size()
		_update_display()
	elif Input.is_action_just_pressed("up"):
		_current_selection_index = (_current_selection_index - 1) % _current_option_menu.options.size()
		_update_display()
	elif Input.is_action_just_pressed("button_a"):
		if !_stay_paused_on_select:
			get_tree().paused = false
		SignalBus.selected_option.emit(_current_option_menu.options[_current_selection_index].id)
	elif Input.is_action_just_pressed("button_b"):
		SignalBus.selected_option.emit("cancel")
		get_tree().paused = false

func _update_display():
	print("---")
	print(_current_option_menu.dialogue)
	print("---")
	var current_option = _current_option_menu.options[_current_selection_index]
	print("[{id}] {name}\n{tooltip}\n".format({
		"id": current_option.id,
		"name": current_option.text,
		"tooltip": current_option.tooltip
	}))
	print("---")
