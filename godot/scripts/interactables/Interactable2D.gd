class_name Interactable2D
extends Node2D

@onready var popup = get_node_or_null("Popup")

func interact(_player: Player):
	pass 

func on_interact_enter(_player: Player):
	if is_instance_valid(popup):
		popup.show()

func on_interact_exit(_player: Player):
	if is_instance_valid(popup):
		popup.hide()
