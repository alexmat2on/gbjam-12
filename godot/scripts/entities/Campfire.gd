extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	_play()

func _play():
	self.play("default")
