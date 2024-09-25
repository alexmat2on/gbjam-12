extends CanvasLayer

const DEFAULT_PALETTE: Array[Color] = [
	Color("#11032c"), 
	Color("#426a45"), 
	Color("#99a376"), 
	Color("#f2c37b")
]

@onready var rect_filter = $ColorRect

@export var color1: Color = DEFAULT_PALETTE[0]
@export var color2: Color = DEFAULT_PALETTE[1]
@export var color3: Color = DEFAULT_PALETTE[2]
@export var color4: Color = DEFAULT_PALETTE[3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect_filter.material.set_shader_parameter("original_palette", DEFAULT_PALETTE)
	rect_filter.material.set_shader_parameter("new_palette", [ color1, color2, color3, color4 ])
