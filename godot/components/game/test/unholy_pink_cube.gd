extends Interactible2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(popup):
		popup.text = "Click me!"

func interact():
	# Do whatever you want your object to do upon an interaction by the player
	PlayerVariables.remove_health()
	if is_instance_valid(popup):
		popup.text = "u fool"

# Can override enter/exit handlers
func on_interact_exit():
	super()
	if is_instance_valid(popup):
		popup.text = "Click me!"
