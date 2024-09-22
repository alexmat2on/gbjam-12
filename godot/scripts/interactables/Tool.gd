extends Interactable2D

@export var tool: Enums.Tool

func interact(player: Player):
	# Hey player, user selected X slot for Y tool
	player.equip_tool(tool, "button_a")
