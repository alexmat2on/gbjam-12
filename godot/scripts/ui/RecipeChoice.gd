extends NinePatchRect

@onready var _selector = $Selector

func select() -> void:
	self._selector.visible = true

func unselect() -> void:
	self._selector.visible = false
