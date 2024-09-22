extends Node

# HUD
signal player_health_updated(new_health: int)

# Menus
signal opened_option_menu(option_menu: OptionMenu, stay_paused_on_select: bool)
signal selected_option(id: String)
