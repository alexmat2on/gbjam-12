extends Node
class_name OptionMenuHandler


func open_menu(menu: OptionMenu, stay_paused_on_select: bool = false):
	SignalBus.selected_option.connect(_on_option_selected)
	SignalBus.opened_option_menu.emit(menu, stay_paused_on_select)
	SoundManager.play(Enums.SoundEffect.BLIP)

func _on_option_selected(option_id):
	SignalBus.selected_option.disconnect(_on_option_selected)
	if owner.has_method("on_option_selected"):
		owner.on_option_selected(option_id)
