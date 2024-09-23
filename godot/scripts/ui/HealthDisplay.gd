extends HBoxContainer

var _heart_scene = preload("res://scenes/ui/heart.tscn")

func _ready():
	SignalBus.player_health_updated.connect(_on_player_health_updated)

func _on_player_health_updated(new_health):
	for child in self.get_children():
		child.queue_free()

	for i in range(new_health):
		_add_heart()

func _add_heart():
	self.add_child(_heart_scene.instantiate())
