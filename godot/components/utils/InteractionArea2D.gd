class_name InteractionArea2D
extends Area2D

@onready var interaction_popup: Label = get_node_or_null("Popup")

func _ready():
	connect("area_entered", self._on_interaction_area_entered)
	connect("area_exited", self._on_interaction_area_exited)

func interact(player: Player):
	get_parent()._on_player_interacted(player)

func _on_interaction_area_entered(interactor):
	if interactor == null || !interactor is Interactor2D:
		return
	
	print("interaction area entered")
	if interactor.set_current_interactible(self):
		#if force_interaction:
			#interactor.force()
		if is_instance_valid(interaction_popup):
			interaction_popup.show()

func _on_interaction_area_exited(interactor):
	if interactor == null || !interactor is Interactor2D:
		return
	
	if is_instance_valid(interaction_popup):
		interaction_popup.hide()
	interactor.exit_interactible(self)
