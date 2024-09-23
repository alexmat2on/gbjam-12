extends Interactable2D

@onready var _cleaver_icon = $CleaverIcon
@onready var _mallet_icon = $MalletIcon
@onready var _flamethrower_icon = $FlamethrowerIcon
@onready var _menu_handler: OptionMenuHandler = $OptionMenuHandler

var option_menu_template: OptionMenu = load("res://resources/tool_select_menu_template.tres")

var _current_player: Player = null
var _current_menu: String = ""

# { Enums.Tool: Icon }
var _tool_icons: Dictionary

func _ready():
	_tool_icons = {
		Enums.Tool.CLEAVER: _cleaver_icon,
		Enums.Tool.MALLET: _mallet_icon,
		Enums.Tool.FLAMETHROWER: _flamethrower_icon
	}

func interact(player: Player):
	# show all tools
	for tool in Enums.Tool.values():
		if _tool_icons.has(tool):
			_tool_icons[tool].show()
		
	_current_player = player
	_current_menu = "a"
	var option_menu_a: OptionMenu = option_menu_template.duplicate(true)
	option_menu_a.dialogue = option_menu_a.dialogue.replace("{button}", "~a")
	_menu_handler.open_menu(option_menu_a, true)
	
func on_option_selected(id: String):
	var selected_tool = _determine_tool_from_option(id)
	if selected_tool == null:
		for tool in Enums.Tool.values():
			if tool == _current_player._equip_state["button_a"].tool || tool == _current_player._equip_state["button_b"].tool:
				_tool_icons[tool].hide()
		_current_player = null
		_current_menu = ""
		return
	
	elif _current_menu == "a":
		_current_player.equip_tool(selected_tool, "button_a")
		_tool_icons[selected_tool].hide()
		_current_menu = "b"
		var option_menu_b: OptionMenu = option_menu_template.duplicate(true)
		option_menu_b.dialogue = option_menu_b.dialogue.replace("{button}", "~b")
		option_menu_b.options = option_menu_b.options.filter(func(option: OptionMenuOption): return option.id != id)
		_menu_handler.open_menu(option_menu_b)
		
	elif _current_menu == "b":
		_current_player.equip_tool(selected_tool, "button_b")
		_tool_icons[selected_tool].hide()
		_current_player = null
		_current_menu = ""

func _determine_tool_from_option(id):
	match id:
		"cleaver":
			return Enums.Tool.CLEAVER
		"mallet":
			return Enums.Tool.MALLET
		"flamethrower":
			return Enums.Tool.FLAMETHROWER
		_:
			return null
