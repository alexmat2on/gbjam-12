extends Label

func _ready():
	SignalBus.time_updated.connect(_on_time_updated)

func _on_time_updated(new_time: float):
	text = str(ceil(new_time))

func _process(delta):
	self.visible = GlobalState.is_gather_mode()
	if GlobalState.pause_tick:
		self.text = "continue"
