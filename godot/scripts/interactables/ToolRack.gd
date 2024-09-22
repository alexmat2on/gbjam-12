extends Interactable2D

@onready var _cleaver_icon = $CleaverIcon
@onready var _mallet_icon = $MalletIcon
@onready var _flamethrower_icon = $FlamethrowerIcon

# { Enums.Tool: Icon }
var _tool_icons: Dictionary

func _ready():
	_tool_icons = {
		Enums.Tool.CLEAVER: _cleaver_icon,
		Enums.Tool.MALLET: _mallet_icon,
		Enums.Tool.FLAMETHROWER: _flamethrower_icon
	}

func interact(player: Player):
	# TODO - pick from menu
	var tool_a = Enums.Tool.CLEAVER
	var tool_b = Enums.Tool.MALLET
	
	# show all tools
	for tool in Enums.Tool.values():
		_tool_icons[tool].show()
	
	# display a menu
		# - stop player mvmt
		# - use d-pad to choose
		# - use "a" to pick a-slot
		# - use "b" to pick b-slot
		# - exit after both picks
	
	# remove selected tools from rack (visual detail)
	_tool_icons[tool_a].hide()
	_tool_icons[tool_b].hide()
	
	# equip selected tools to player
	player.equip_tool(tool_a, "button_a")
	player.equip_tool(tool_b, "button_b")
