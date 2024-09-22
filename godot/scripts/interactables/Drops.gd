extends Interactable2D

@export var item: Enums.Item

func _ready() -> void:
	pass

func on_interact_enter(player):
	Inventory.add(item, 1)
	queue_free()

func on_interact_exit(player):
	pass

func interact(_player):
	pass
