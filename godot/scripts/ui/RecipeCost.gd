extends Control

var IngredientCost = preload("res://scenes/ui/ingredient_cost.tscn")

@onready var _ingredient_costs: HBoxContainer = $IngredientCosts

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_ingredient_costs()

func clear_ingredient_costs() -> void:
	for child in self._ingredient_costs.get_children():
		child.queue_free()

func add_ingredient_cost(item: Enums.Item, amount: int) -> void:
	var ingredient_cost = IngredientCost.instantiate()
	self._ingredient_costs.add_child(ingredient_cost)
	ingredient_cost.set_amount(amount)
	ingredient_cost.set_texture(RecipeUtils.get_item_texture(item))
