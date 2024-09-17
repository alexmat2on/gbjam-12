extends Node

const Appliance = preload("res://components/cooking/Applicance.gd")

# Finished dishes are carried in the chef's hands. This can be part of player.gd whenever.
var _hands = null

var stockpot: Appliance
var grill: Appliance
var fryer: Appliance

func _ready():
	stockpot = Appliance.new(ApplianceType.STOCKPOT)
	grill = Appliance.new(ApplianceType.GRILL)
	fryer = Appliance.new(ApplianceType.FRYER)

	for child in [stockpot, grill, fryer]:
		self.add_child(child)
		child.dish_pickup.connect(carry_dish)

# TODO: Move below methods to be a part of the player's implementation.

func dish_in_hands() -> int:
	return _hands

func carry_dish(recipe: int) -> void:
	if not hands_full():
		_hands = recipe

func hands_full() -> bool:
	return _hands != null

func drop_hands() -> void:
	_hands = null
