extends Node

func _input(event) -> void:
	if event is InputEventKey and event.pressed and event.shift_pressed:
		if event.keycode == KEY_Z:
			Inventory.add(ItemType.ZOMBIE_FLESH, 1)
		elif event.keycode == KEY_E:
			Inventory.add(ItemType.ECTO_SEASONING, 1)
		elif event.keycode == KEY_B:
			Inventory.add(ItemType.BONES, 1)
