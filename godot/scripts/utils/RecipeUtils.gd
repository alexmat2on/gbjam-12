extends Node

# Dictionary type:
# {
#   [Enums.Recipe]: {
#     "title": String,
#     "cost": { [Enums.Item]: int },
#     "cook_time": float,
#     "burn_time": float,
#     "texture": Texture2D
#   }
# }
const _recipe_data: Dictionary = {
	Enums.Recipe.ZOMBIE_STEW: {
		"title": "zombie stew",
		"cost": {
			Enums.Item.BONES: 1,
			Enums.Item.ZOMBIE_FLESH: 1
		},
		"cook_time": 9.5,
		"burn_time": 16.0,
		"texture": preload("res://art/cooking/zombie-stew.png")
	},
	Enums.Recipe.ZOMBIE_STEAK: {
		"title": "zombie steak",
		"cost": {
			Enums.Item.ZOMBIE_FLESH: 1,
			Enums.Item.ECTO_SEASONING: 1
		},
		"cook_time": 12.0,
		"burn_time": 8.0,
		"texture": preload("res://art/cooking/zombie-steak.png")
	},
	Enums.Recipe.BONE_CHIPS: {
		"title": "bone chips",
		"cost": {
			Enums.Item.BONES: 1,
			Enums.Item.ECTO_SEASONING: 1
		},
		"cook_time": 7.5,
		"burn_time": 6.0,
		"texture": preload("res://art/cooking/bone-chips.png")
	}
}

const _item_data: Dictionary = {
	Enums.Item.BONES: {
		"title": "b",
		"texture": preload("res://art/cooking/ingredients/bone-ing.png")
	},
	Enums.Item.ZOMBIE_FLESH: {
		"title": "z",
		"texture": preload("res://art/cooking/ingredients/zombie-flesh-ing.png")
	},
	Enums.Item.ECTO_SEASONING: {
		"title": "e",
		"texture": preload("res://art/cooking/ingredients/ecto-seasoning-ing.png")
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

func get_recipe_texture(recipe: Enums.Recipe) -> Texture2D:
	return _recipe_data[recipe]["texture"]

func get_item_texture(item: Enums.Item) -> Texture2D:
	return _item_data[item]["texture"]

func get_recipe_title(recipe: Enums.Recipe) -> String:
	return _recipe_data[recipe]["title"]

func get_item_title(item: Enums.Item) -> String:
	return _item_data[item]["title"]

# Returns true if there are enough items in the inventory to cook the recipe, false otherwise.
func sufficient_items_for_recipe(recipe: Enums.Recipe) -> bool:
	var recipe_cost = get_cost(recipe)
	for item in recipe_cost:
		if Inventory.count(item) < recipe_cost[item]:
			return false
	return true
