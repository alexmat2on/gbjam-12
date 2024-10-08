extends Node

# HUD
signal player_health_updated(new_health: int)
signal time_updated(new_time: float)

# Menus
signal opened_option_menu(option_menu: OptionMenu, stay_paused_on_select: bool)
signal selected_option(id: String)
signal player_tool_equipped(tool: Enums.Tool, slot: String)
