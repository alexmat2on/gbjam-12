extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.visible = GlobalState.get_orders() != 0
	$OrdersLeftLabel.text = str(GlobalState.get_orders())
