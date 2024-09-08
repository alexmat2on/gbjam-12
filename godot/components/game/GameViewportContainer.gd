extends SubViewportContainer

const gameboy_rezz = Vector2(160, 144)
const scale_factor = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# position the subviewport to the center of the window
	size = gameboy_rezz
	scale = Vector2(scale_factor, scale_factor)
	var vp := get_viewport_rect().size
	
	# positioning is relative to the top-left corner of the node
	var centered := vp / 2 - (size * scale / 2)
	set_global_position(centered)
