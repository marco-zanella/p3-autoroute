extends Control

@onready var content = %Content
@onready var route_editor = %RouteEditor
@onready var status_bar = %StatusBar

func _on_main_menu_bar_route_open():
	content.current_tab = 0
	route_editor.select_folder()


func _on_main_menu_bar_route_show():
	content.current_tab = 0
	status_bar.set_status("Opening route editor")


func _on_main_menu_bar_route_close():
	content.current_tab = 0
	route_editor.close_folder()


func _on_main_menu_bar_sorting_presets():
	content.current_tab = 1
	status_bar.set_status("Opening sorting presets")


func _on_main_menu_bar_price_presets():
	content.current_tab = 2
	status_bar.set_status("Opening price presets")


func _on_main_menu_bar_route_presets():
	content.current_tab = 3
	status_bar.set_status("Opening route presets [not implemented]")
