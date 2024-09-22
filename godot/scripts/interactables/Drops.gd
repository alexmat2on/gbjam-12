extends Interactable2D

@export var item: Enums.Item

func _ready() -> void:
	pass

func interact(_player: Player):
	pass 

func on_interact_enter(_player: Player):
	Inventory.add(item, 1)
	queue_free()

func on_interact_exit(_player: Player):
	pass
