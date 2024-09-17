extends Node

# The chef (i.e. the player) doesn't need to do as much manual manipulation of the inventory,
# since recipes will automatically deduct items from the inventory and the chef cares about
# the quantity of items rather than how they're ordered. Therefore, we can just keep a dictionary
# of item counters.
var inventory = {}

# Items such as ingredients can be supplied to the inventory's methods like so:
# Inventory.add(Item.ZOMBIE_FLESH)
# var removed = Inventory.remove(Item.ECTO_SEASONING, 2)

func add(item: int, amount: int = 1) -> void:
	inventory[item] = inventory.count(item) + amount

# Returns true if removed successfully, false if amount is greater than count in inventory.
func remove(item: int, amount: int = 1) -> bool:
	if not inventory.can_remove(item, amount):
		return false
	inventory[item] = inventory.count(item) - amount
	return true

func can_remove(item: int, amount: int = 1) -> bool:
	return inventory.count(item) >= amount

func count(item: int) -> int:
	return inventory.get(item, 0)
