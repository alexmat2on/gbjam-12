extends AnimatedSprite2D

const INTERVAL = 3.0

var _forward: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_wait_to_play()

func _wait_to_play():
	get_tree().create_timer(INTERVAL).timeout.connect(_play)

func _play():
	if _forward:
		self.play("default")
	else:
		self.play_backwards("default")
	_forward = not _forward
	_wait_to_play()
