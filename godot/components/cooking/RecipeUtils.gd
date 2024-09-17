extends Node

const recipes_for_appliance = {
	Appliance.STOCKPOT: [Recipe.ZOMBIE_STEW],
	Appliance.GRILL: [Recipe.ZOMBIE_STEAK],
	Appliance.FRYER: [Recipe.BONE_CHIPS]
}

const recipe_costs = {
	Recipe.ZOMBIE_STEW: {
		Item.BONES: 1,
		Item.ZOMBIE_FLESH: 1
	},
	Recipe.ZOMBIE_STEAK: {
		Item.ZOMBIE_FLESH: 1,
		Item.ECTO_SEASONING: 1
	},
	Recipe.BONE_CHIPS: {
		Item.BONES: 1,
		Item.ECTO_SEASONING: 1
	}
}

const recipe_cooking_times = {
	Recipe.ZOMBIE_STEW: 10.0,
	Recipe.ZOMBIE_STEAK: 12.0,
	Recipe.BONE_CHIPS: 8.0
}

# Returns an array of all recipes for the given appliance.
# Example usage:
# var recipes = get_recipes_for_appliance(Appliance.STOCKPOT)
func get_recipes_for_appliance(appliance: int) -> Array[int]:
	return recipes_for_appliance[appliance].duplicate()

# Returns the costs of the given recipe as a dictionary of required items.
# Example usage:
# var recipe_cost = get_recipe_cost(Recipe.ZOMBIE_STEW)
func get_recipe_cost(recipe: int) -> Dictionary:
	return recipe_costs[recipe].duplicate()

# Returns the cooking time of the recipe in seconds.
func get_recipe_cooking_time(recipe: int) -> float:
	return recipe_cooking_times[recipe]

# Returns true if there are enough items in the inventory to cook the recipe, false otherwise.
func can_cook_recipe(recipe: int) -> bool:
	var recipe_cost = get_recipe_cost(recipe)
	for item in recipe_cost:
		if Inventory.count(item) < recipe_cost[item]:
			return false
	return true
