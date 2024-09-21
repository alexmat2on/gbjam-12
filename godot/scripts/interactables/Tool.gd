extends Interactable2D

@export var tool: Enums.Tool

func interact(player: Player):
	player.set_tool(Enums.ToolSlot.SLOT_A, tool)
