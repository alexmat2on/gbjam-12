extends Interactable2D

# We're leaving some potential for the appliances to have larger capacity (max 4),
# perhaps through upgrades. Keeping things simple for now with capacities of 1.
# Think of the state as a kitchen burner with 4 quadrants.
@export var appliance_name: String
@export var recipes: Array[Enums.Recipe]
@export var capacity: int = 1
@export var texture: Texture2D
@export var glow_texture: Texture2D

@onready var _sprite: Sprite2D = $Area2D/CollisionShape2D/Sprite2D

var _state: Array
signal dish_pickup(recipe: Enums.Recipe)

func _ready() -> void:
	self._state = [null, null, null, null]
	self._sprite.texture = self.texture

func on_interact_enter():
	super.on_interact_enter()
	self._sprite.texture = self.glow_texture

func on_interact_exit():
	super.on_interact_exit()
	self._sprite.texture = self.texture

func interact():
	print("available recipes for appliance: " + str(self.get_recipes()))

# Attempts to cook the recipe on the appliance.
# Returns true if cooking began successfully, false otherwise.
func cook(recipe: Enums.Recipe) -> bool:
	if not self.can_cook(recipe):
		return false

	var cooking_time = RecipeUtils.get_cooking_time(recipe)
	var burn_time = RecipeUtils.get_burn_time(recipe)
	var dish_slot = self._state.find(null)

	var cook_timer = self._create_timer(cooking_time)
	cook_timer.timeout.connect(_on_cooking_complete.bind(dish_slot))
	self.add_child(cook_timer)

	var burn_timer = self._create_timer(burn_time)
	burn_timer.timeout.connect(_on_burned.bind(dish_slot))
	self.add_child(burn_timer)

	var recipe_cost = RecipeUtils.get_cost(recipe)
	for item in recipe_cost:
		Inventory.remove(item, recipe_cost[item])

	var dish_in_progress = {
		"recipe": recipe,
		"ready": false,
		"burned": false,
		"cook_timer": cook_timer,
		"burn_timer": burn_timer
	}
	self._state[dish_slot] = dish_in_progress
	cook_timer.start()
	return true

# Returns true if all the requirements for cooking the given recipe are satisfied:
# - There must be free space on the appliance.
# - The recipe must be compatible with the appliance.
# - Inventory needs to have the required items.
func can_cook(recipe: Enums.Recipe) -> bool:
	if not self.is_free():
		print("No space to cook recipe!")
		return false
	if not self.get_recipes().has(recipe):
		print("This recipe cannot be cooked on this appliance!")
		return false
	if not RecipeUtils.sufficient_items_for_recipe(recipe):
		print("Insufficient items for recipe!")
		return false
	return true

# Picks up the finished dish at the given slot.
# Returns true if pickup was successful, false otherwise.
func pickup(slot: int = 0) -> bool:
	if self._state[slot] == null:
		return false

	# TODO: Handle hands full

	var dish = self._state[slot]
	if not dish["ready"]:
		print("Dish is not ready to be collected!")
		return false

	dish_pickup.emit(dish["recipe"])
	for timer in [dish["cook_timer"], dish["burn_timer"]]:
		if timer != null:
			timer.stop()
			timer.queue_free()
	self._state[slot] = null
	return true

# Clears the dish at the given slot.
func clear(slot: int = 0) -> void:
	if self._state[slot] == null:
		return

	var dish = self._state[slot]
	for timer in [dish["cook_timer"], dish["burn_timer"]]:
		if timer != null:
			timer.stop()
			timer.queue_free()
	self._state[slot] = null

# Returns true if there is enough capacity to cook a new dish, false otherwise.
func is_free() -> bool:
	for i in range(self.capacity):
		if self._state[i] == null:
			return true
	return false

# Returns an array of all recipes for the appliance.
func get_recipes() -> Array:
	return self.recipes

# Runs whenever a dish is finished cooking on an appliance slot.
func _on_cooking_complete(slot: int) -> void:
	var dish = self._state[slot]
	dish["ready"] = true
	dish["cook_timer"].queue_free()
	dish["cook_timer"] = null
	dish["burn_timer"].start()

# Runs whenever a dish is burned on an appliance slot.
func _on_burned(slot: int) -> void:
	var dish = self._state[slot]
	dish["ready"] = false
	dish["burned"] = true
	dish["burn_timer"].queue_free()
	dish["burn_timer"] = null

func _create_timer(time: float) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.timer_process_callback = Timer.TIMER_PROCESS_PHYSICS
	return timer
