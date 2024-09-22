extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$BoneCount.text = str(Inventory.count(Enums.Item.BONES))
	$ZombieFleshCount.text = str(Inventory.count(Enums.Item.ZOMBIE_FLESH))
	$EctoCount.text = str(Inventory.count(Enums.Item.ECTO_SEASONING))
