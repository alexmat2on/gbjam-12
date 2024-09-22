extends Node

@onready var slot_a = $BgA/SlotA
@onready var slot_b = $BgB/SlotB

func _ready():
	SignalBus.player_tool_equipped.connect(_on_player_tool_equipped)

func _on_player_tool_equipped(tool: Enums.Tool, slot: String):
	match slot:
		"button_a":
			slot_a.texture = Constants.ToolTexture[tool]
		"button_b":
			slot_b.texture = Constants.ToolTexture[tool]
