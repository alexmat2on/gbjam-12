extends Interactable2D

@onready var appliance = $"../Appliance"

func on_interact_enter():
	super.on_interact_enter()

func on_interact_exit():
	super.on_interact_exit()

func interact():
	print("available recipes for appliance: " + str(appliance.get_recipes()))
