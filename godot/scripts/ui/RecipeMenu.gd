extends Control

var RecipeChoice = preload("res://scenes/ui/recipe_choice.tscn")

var _recipes: Array = []
var _index: int = 0
var _current_appliance

@export var player: Player

@onready var _recipe_choices_container: HBoxContainer = $RecipesMargin/RecipeChoicesContainer
@onready var _recipe_info: MarginContainer = $RecipeInfoMargin
@onready var _recipe_title: Label = $RecipeInfoMargin/RecipeInfo/RecipeTitleMargin/RecipeTitle
@onready var _recipe_cost: Control = $RecipeInfoMargin/RecipeInfo/RecipeCostMargin/RecipeCost

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in _recipe_choices_container.get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not self.visible:
		return
	if Input.is_action_pressed("left"):
		self._cursor_left()
	elif Input.is_action_pressed("right"):
		self._cursor_right()
	elif Input.is_action_pressed("button_a"):
		self.confirm_recipe()
	elif Input.is_action_pressed("button_b"):
		self.hide_menu()

func set_recipes(new_recipes: Array, appliance) -> void:
	self._current_appliance = appliance
	self._index = 0
	for recipe in self._recipes:
		recipe["node"].queue_free()
	self._recipes = []
	for new_recipe in new_recipes:
		var recipe_choice = RecipeChoice.instantiate()
		_recipe_choices_container.add_child(recipe_choice)
		recipe_choice.set_recipe_icon(new_recipe)
		self._recipes.append({
			"node": recipe_choice,
			"type": new_recipe,
		})
	_update_selection()

func _cursor_left() -> void:
	if self._index == 0:
		self._index = len(self._recipes) - 1
	else:
		self._index -= 1
	_update_selection()

func _cursor_right() -> void:
	if self._index == len(self._recipes) - 1:
		self._index = 0
	else:
		self._index += 1
	_update_selection()

func _update_selection() -> void:
	for i in range(len(self._recipes)):
		var recipe_choice = self._recipes[i]["node"]
		if i == self._index:
			recipe_choice.select()
		else:
			recipe_choice.unselect()

	# update recipe title
	var selected_choice = self._recipes[self._index]
	var recipe_type = selected_choice["type"]
	self._recipe_title.text = RecipeUtils.get_recipe_title(recipe_type)

	# update recipe cost
	self._recipe_cost.clear_ingredient_costs()
	var recipe_costs = RecipeUtils.get_cost(recipe_type)
	for item_type in recipe_costs:
		var item_amount = recipe_costs[item_type]
		self._recipe_cost.add_ingredient_cost(item_type, item_amount)

func show_menu() -> void:
	self.visible = true
	self.player.prevent_movement()

func hide_menu() -> void:
	self.visible = false
	self.player.enable_movement()

func confirm_recipe() -> void:
	var selected_choice = self._recipes[self._index]
	var recipe_type = selected_choice["type"]
	self._current_appliance.cook(recipe_type)
	self.hide_menu()
