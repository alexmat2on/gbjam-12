extends Node

# Dictionary type:
# {
#   [Enums.Recipe]: {
#     "cost": { [Enums.Item]: int }
#     "cook_time": float
#     "burn_time": float
#   }
# }
const _recipe_data: Dictionary = {
	Enums.Recipe.ZOMBIE_STEW: {
		"cost": {
			Enums.Item.BONES: 1,
			Enums.Item.ZOMBIE_FLESH: 1
		},
		"cook_time": 10.0,
		"burn_time": 12.0
	},
	Enums.Recipe.ZOMBIE_STEAK: {
		"cost": {
			Enums.Item.ZOMBIE_FLESH: 1,
			Enums.Item.ECTO_SEASONING: 1
		},
		"cook_time": 12.0,
		"burn_time": 8.0
	},
	Enums.Recipe.BONE_CHIPS: {
		"cost": {
			Enums.Item.BONES: 1,
			Enums.Item.ECTO_SEASONING: 1
		},
		"cook_time": 8.0,
		"burn_time": 6.0
	}
}

# Returns the costs of the given recipe as a dictionary of required items.
# Example usage:
# var recipe_cost = get_cost(Recipe.ZOMBIE_STEW)
func get_cost(recipe: Enums.Recipe) -> Dictionary:
	return _recipe_data[recipe]["cost"].duplicate()

# Returns the cooking time of the recipe in seconds.
func get_cooking_time(recipe: Enums.Recipe) -> float:
	return _recipe_data[recipe]["cook_time"]

# Returns the burn time of the recipe in seconds.
# Burn time is the time it takes for a dish to get burnt after it's done cooking.
func get_burn_time(recipe: Enums.Recipe) -> float:
	return _recipe_data[recipe]["burn_time"]

# Returns true if there are enough items in the inventory to cook the recipe, false otherwise.
func sufficient_items_for_recipe(recipe: Enums.Recipe) -> bool:
	var recipe_cost = get_cost(recipe)
	for item in recipe_cost:
		if Inventory.count(item) < recipe_cost[item]:
			return false
	return true