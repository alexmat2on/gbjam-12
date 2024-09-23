extends Interactable2D
class_name Map

const LEVEL_PATH_TEMPLATE = "res://scenes/levels/{id}.tscn"

@onready var _menu_handler: OptionMenuHandler = $OptionMenuHandler

var map_menu: OptionMenu = load("res://resources/map_menu.tres")

func interact(player: Player):
	_menu_handler.open_menu(map_menu)
	
func on_option_selected(id: String):
	var current_scene_id = get_tree().current_scene.name
	if id == "cancel" || id == current_scene_id:
		return
	else:
		get_tree().change_scene_to_file(LEVEL_PATH_TEMPLATE.format({
			"id": id
		}))
