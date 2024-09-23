extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$DayLabel.text = str(GlobalState.get_day() + 1)
