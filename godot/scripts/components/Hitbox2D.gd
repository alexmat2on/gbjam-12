class_name Hitbox2D
extends Area2D

@export var hit_mod: Array[Enums.HitModifier] = []
@export var damage = 10

signal hit_something(body)
