class_name Interactable2D
extends Node2D

@onready var popup = get_node_or_null("Popup")

func interact():
	pass 

func on_interact_enter():
	if is_instance_valid(popup):
		popup.show()

func on_interact_exit():
	if is_instance_valid(popup):
		popup.hide()
