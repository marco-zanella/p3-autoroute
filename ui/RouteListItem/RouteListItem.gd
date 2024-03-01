extends PanelContainer

signal edit(route: Route)
signal rename(route: Route)
signal duplicate(route: Route)
signal delete(route: Route)

@onready var route_name_label = %RouteNameLabel
@onready var context_menu = $ContextMenu
var route: Route

func set_route(new_route: Route) -> void:
	route = new_route
	route_name_label.text = route.name.replace(".rou", "")


func _on_edit_button_pressed():
	edit.emit(route)


func _on_rename_button_pressed():
	rename.emit(route)


func _on_duplicate_button_pressed():
	duplicate.emit(route)


func _on_delete_button_pressed():
	delete.emit(route)


func _on_route_name_label_gui_input(event) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		edit.emit(route)
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		context_menu.show()
		context_menu.position = get_global_mouse_position()


func _on_context_menu_id_pressed(id: int) -> void:
	match id:
		0: edit.emit(route)
		1: rename.emit(route)
		2: duplicate.emit(route)
		3: delete.emit(route)
