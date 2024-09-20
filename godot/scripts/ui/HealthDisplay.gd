extends Label

func _ready():
	SignalBus.player_health_updated.connect(_on_player_health_updated)

func _on_player_health_updated(new_health):
	text = "<".repeat(new_health)
