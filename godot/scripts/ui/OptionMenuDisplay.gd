extends CanvasLayer
class_name OptionMenuDisplay

@onready var dialogue_label = $DialogueRect/DialogueLabel
@onready var options_container = $OptionsContainer

@export var option_rect: PackedScene

var _option_rects: Array[NinePatchRect]
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
	visible = true
	_init_display()

func _process(delta):
	if Input.is_action_just_pressed("down"):
		_current_selection_index = (_current_selection_index + 1) % _current_option_menu.options.size()
		_update_display()
	elif Input.is_action_just_pressed("up"):
		_current_selection_index = (_current_selection_index - 1)
		if _current_selection_index < 0:
			_current_selection_index += _current_option_menu.options.size()
		_update_display()
	elif Input.is_action_just_pressed("button_a"):
		visible = false
		if !_stay_paused_on_select:
			get_tree().paused = false
		SignalBus.selected_option.emit(_current_option_menu.options[_current_selection_index].id)
	elif Input.is_action_just_pressed("button_b"):
		visible = false
		get_tree().paused = false
		SignalBus.selected_option.emit("cancel")

func _init_display():
	for child in options_container.get_children():
		options_container.remove_child(child)
		child.queue_free()
	
	_option_rects = []
		
	dialogue_label.text = _current_option_menu.dialogue
	for i in range(_current_option_menu.options.size()):
		var option_rect_instance = option_rect.instantiate()
		option_rect_instance.get_node("OptionLabel").text = _current_option_menu.options[i].id
		option_rect_instance.get_node("SelectedIndicator").visible = _current_selection_index == i
		options_container.add_child(option_rect_instance)
		_option_rects.append(option_rect_instance)

func _update_display():
	print("index: ", _current_selection_index)
	for i in range(_option_rects.size()):
		_option_rects[i].get_node("SelectedIndicator").visible = _current_selection_index == i
