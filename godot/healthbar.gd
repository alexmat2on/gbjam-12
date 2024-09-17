extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = " " + "<".repeat(PlayerVariables.get_health())
