extends Node

# The chef (i.e. the player) doesn't need to do as much manual manipulation of the inventory,
# since recipes will automatically deduct items from the inventory and the chef cares about
# the quantity of items rather than how they're ordered. Therefore, we can just keep a dictionary
# of item counters.
var _inventory = {}

# Items such as ingredients can be supplied to the inventory's methods like so:
# Inventory.add(Item.ZOMBIE_FLESH)
# var removed = Inventory.remove(Item.ECTO_SEASONING, 2)

func add(item: int, amount: int = 1) -> void:
	_inventory[item] = self.count(item) + amount

# Returns true if removed successfully, false if amount is greater than count in inventory.
func remove(item: int, amount: int = 1) -> bool:
	if not self.can_remove(item, amount):
		return false
	_inventory[item] = self.count(item) - amount
	return true

func can_remove(item: int, amount: int = 1) -> bool:
	return self.count(item) >= amount

func count(item: int) -> int:
	return _inventory.get(item, 0)
