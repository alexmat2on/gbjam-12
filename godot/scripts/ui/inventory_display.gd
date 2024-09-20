extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bones = "b:" + str(Inventory.count(ItemType.BONES))
	var zombie_flesh = "z:" + str(Inventory.count(ItemType.ZOMBIE_FLESH))
	var ecto = "e:" + str(Inventory.count(ItemType.ECTO_SEASONING))
	text = " " + bones + " " + zombie_flesh + " " + ecto
