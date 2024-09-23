extends Label

func _ready():
	SignalBus.time_updated.connect(_on_time_updated)

func _on_time_updated(new_time: float):
	text = str(ceil(new_time))
