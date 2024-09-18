class_name Interactor2D
extends Area2D

var current_interactible = null
var is_interacting = false

func interact(player: Player):
	if !is_interacting:
		print("interacted")
		current_interactible.interact(player)
		is_interacting = true

func has_interaction():
	return is_instance_valid(current_interactible)

func set_current_interactible(interactible: InteractionArea2D):
	if !is_interacting:
		print("setting interactible")
		current_interactible = interactible
		return true
	return false

func exit_interactible(interactible: InteractionArea2D):
	if !is_interacting && current_interactible == interactible:
		print("unsetting interactible")
		current_interactible = null
