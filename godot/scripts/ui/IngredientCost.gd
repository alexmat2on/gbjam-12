extends HBoxContainer

@onready var _amount: Label = $IngredientAmount
@onready var _texture: TextureRect = $IngredientTexture

func set_amount(amount: int) -> void:
	self._amount.text = str(amount) + "*"

func set_texture(texture: Texture2D) -> void:
	self._texture.texture = texture
