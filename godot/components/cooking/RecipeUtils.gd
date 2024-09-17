extends Node

const _recipes_for_appliance = {
	ApplianceType.STOCKPOT: [RecipeType.ZOMBIE_STEW],
	ApplianceType.GRILL: [RecipeType.ZOMBIE_STEAK],
	ApplianceType.FRYER: [RecipeType.BONE_CHIPS]
}

const _recipe_costs = {
	RecipeType.ZOMBIE_STEW: {
		ItemType.BONES: 1,
		ItemType.ZOMBIE_FLESH: 1
	},
	RecipeType.ZOMBIE_STEAK: {
		ItemType.ZOMBIE_FLESH: 1,
		ItemType.ECTO_SEASONING: 1
	},
	RecipeType.BONE_CHIPS: {
		ItemType.BONES: 1,
		ItemType.ECTO_SEASONING: 1
	}
}

const _recipe_cooking_times = {
	RecipeType.ZOMBIE_STEW: 10.0,
	RecipeType.ZOMBIE_STEAK: 12.0,
	RecipeType.BONE_CHIPS: 8.0
}

const _recipe_burn_times = {
	RecipeType.ZOMBIE_STEW: 12.0,
	RecipeType.ZOMBIE_STEAK: 8.0,
	RecipeType.BONE_CHIPS: 6.0
}

# Returns an array of all recipes for the given appliance.
# Example usage:
# var recipes = get_recipes_for_appliance(Appliance.STOCKPOT)
func get_recipes_for_appliance(appliance: int) -> Array[int]:
	return _recipes_for_appliance[appliance].duplicate()

# Returns the costs of the given recipe as a dictionary of required items.
# Example usage:
# var recipe_cost = get_cost(Recipe.ZOMBIE_STEW)
func get_cost(recipe: int) -> Dictionary:
	return _recipe_costs[recipe].duplicate()

# Returns the cooking time of the recipe in seconds.
func get_cooking_time(recipe: int) -> float:
	return _recipe_cooking_times[recipe]

# Returns the burn time of the recipe in seconds.
# Burn time is the time it takes for a dish to get burnt after it's done cooking.
func get_burn_time(recipe: int) -> float:
	return _recipe_burn_times[recipe]

# Returns true if there are enough items in the inventory to cook the recipe, false otherwise.
func sufficient_items_for_recipe(recipe: int) -> bool:
	var recipe_cost = get_cost(recipe)
	for item in recipe_cost:
		if Inventory.count(item) < recipe_cost[item]:
			return false
	return true
