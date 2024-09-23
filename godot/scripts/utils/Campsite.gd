extends Node2D
class_name Campsite

@onready var _menu_handler: OptionMenuHandler = $OptionMenuHandler

@onready var _gather_intro_menu_1 = load("res://resources/gather_intro_menu_1.tres")
@onready var _gather_intro_menu_2 = load("res://resources/gather_intro_menu_2.tres")
@onready var _serve_intro_menu_1 = load("res://resources/serve_intro_menu_1.tres")
@onready var _serve_intro_menu_2 = load("res://resources/serve_intro_menu_2.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalState._day == 0:
		match GlobalState._game_state:
			GlobalState.GameState.SETUP:
				_menu_handler.open_menu(_gather_intro_menu_1, true)
			GlobalState.GameState.SERVE:
				_menu_handler.open_menu(_serve_intro_menu_1, true)

func on_option_selected(id):
	if id == "next":
		match GlobalState._game_state:
			GlobalState.GameState.SETUP:
				_menu_handler.open_menu(_gather_intro_menu_2)
			GlobalState.GameState.SERVE:
				_menu_handler.open_menu(_serve_intro_menu_2)
