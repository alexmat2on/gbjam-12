extends Node

# The stream to play as the background music.
@export var stream: AudioStream

# If true, the stream will play as soon as this node enters the scene tree.
@export var autoplay: bool

var _asp: AudioStreamPlayer

func _ready():
	_asp = AudioStreamPlayer.new()
	_asp.stream = stream
	self.add_child(_asp)

	if autoplay:
		_asp.play()

func toggle():
	_asp.stop() if _asp.playing else _asp.play()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M:
			toggle()
