extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var bones = "b:" + str(Inventory.count(Enums.Item.BONES))
	var zombie_flesh = "z:" + str(Inventory.count(Enums.Item.ZOMBIE_FLESH))
	var ecto = "e:" + str(Inventory.count(Enums.Item.ECTO_SEASONING))
	text = " " + bones + " " + zombie_flesh + " " + ecto
