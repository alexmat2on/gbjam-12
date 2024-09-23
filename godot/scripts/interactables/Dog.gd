extends Interactable2D

@onready var doggo = $Area2D/CollisionShape2D/Doggo

func _ready():
	$Label.visible = false

func on_interact_enter(player):
	doggo.play("default")

func on_interact_exit(player):
	doggo.play_backwards("default")

func interact(_player):
	$Label.visible = true
	$AnimationPlayer.play("heart")
	$AnimationPlayer.animation_finished.connect(_on_heart_anim_end)

func _on_heart_anim_end(_anim) -> void:
	$Label.visible = false
