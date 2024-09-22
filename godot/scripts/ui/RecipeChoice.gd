extends NinePatchRect

@onready var _selector: Label = $Selector
@onready var _recipe_icon: TextureRect = $RecipeIconMargin/RecipeIcon

func select() -> void:
	self._selector.visible = true

func unselect() -> void:
	self._selector.visible = false

func set_recipe_icon(recipe: Enums.Recipe) -> void:
	self._recipe_icon.texture = RecipeUtils.get_recipe_texture(recipe)
