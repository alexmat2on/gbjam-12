extends Node2D
class_name ProximitySpawner

@onready var spawner: Spawner = $Spawner
@onready var detector: Area2D = $Detector2D

@export var invert_detection: bool = false

func _ready():
	detector.body_entered.connect(_player_entered_proximity if !invert_detection else _player_exited_proximity)
	detector.body_exited.connect(_player_exited_proximity if !invert_detection else _player_entered_proximity)

func _player_entered_proximity(player):
	spawner.enable_auto_spawn()
	
func _player_exited_proximity(player):
	spawner.disable_auto_spawn()
