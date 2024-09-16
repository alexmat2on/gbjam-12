extends Node

# The chef (i.e. the player) doesn't need to do as much manual manipulation of the inventory,
# since recipes will automatically deduct items from the inventory and the chef cares about
# the quantity of items rather than how they're ordered. Therefore, we can just keep a dictionary
# of item counters.
var inventory = {}

# Ingredients can be supplied to the inventory's methods like so:
# inventory.add(Ingredient.ZOMBIE_FLESH)
# var removed = inventory.remove(Ingredient.ECTO_SEASONING, 2)

func add(ingredient: int, amount: int = 1) -> void:
	var ingredient_count = inventory.count(ingredient)
	inventory[ingredient] = ingredient_count + amount

# Returns true if removed successfully, false if amount is greater than count in inventory.
func remove(ingredient: int, amount: int = 1) -> bool:
	if not inventory.can_remove(ingredient, amount):
		return false
	inventory[ingredient] = inventory.count(ingredient) - amount
	return true

func can_remove(ingredient: int, amount: int = 1) -> bool:
	return inventory.count(ingredient) >= amount

func count(ingredient: int) -> int:
	return inventory.get(ingredient, 0)
