extends Label

var _health: int;

func _ready():
	SignalBus.player_health_updated.connect(_on_player_health_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "<".repeat(_health)

func _on_player_health_updated(new_health):
	print("new health val!")
	_health = new_health
