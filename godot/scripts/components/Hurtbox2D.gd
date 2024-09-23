class_name Hurtbox2D
extends Area2D


@export var can_take_damage = true
@export var hurt_mod: Array[Enums.HurtModifier] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self._on_hitbox_entered)


func _on_hitbox_entered(hitbox):
	if !can_take_damage || hitbox == null || !hitbox is Hitbox2D:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox, hurt_mod)
		hitbox.hit_something.emit(owner)
	else:
		print("owner does not have take_damage")
