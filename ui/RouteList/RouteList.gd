extends VBoxContainer

signal folder_selected(folder: String)
signal new_route(route: Route)
signal route_selected(route: Route)
signal route_renamed(route: Route, new_name: String)
signal route_duplicated(route: Route, new_name: String)
signal route_deleted(route: Route)

@export var route_mapper: RouteBinaryMapperNode
@onready var search_box = %SearchBox
@onready var available_routes_container = %AvailableRoutesContainer
@onready var routes_number_label = %RoutesNumberLabel
@onready var route_list = %Routes
@onready var add_button = %AddButton
@onready var select_folder = %SelectFolder
@onready var file_dialog = %FileDialog
@onready var delete_confirmation_dialog = %DeleteConfirmationDialog
@onready var route_name_dialog = %RouteNameDialog
var route_list_item_scene = preload("res://ui/RouteListItem/RouteListItem.tscn")
var routes: Array[Route] = []


func display_routes() -> void:
	var counter = 0
	clear_routes()
	for route in routes:
		if search_matches(route.name):
			spawn_route(route)
			counter += 1
	routes_number_label.text = str(counter)


func clear_routes() -> void:
	for route in route_list.get_children():
		route.queue_free()


func search_matches(text: String) -> bool:
	return search_box.text == "" or text.to_lower().contains(search_box.text.to_lower())


func spawn_route(route: Route) -> void:
	var route_list_item = route_list_item_scene.instantiate()
	route_list.add_child(route_list_item)
	route_list_item.set_route(route)
	route_list_item.connect("edit", func (selected_route: Route): route_selected.emit(selected_route))
	route_list_item.connect("rename", _on_rename_route)
	route_list_item.connect("duplicate", _on_duplicate_route)
	route_list_item.connect("delete", _on_delete_route)


func close() -> void:
	routes = []
	search_box.hide()
	available_routes_container.hide()
	display_routes()
	add_button.disabled = true


func _on_select_folder_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_dir_selected(directory: String) -> void:
	route_mapper.set_path(directory)
	routes = route_mapper.search()
	search_box.show()
	available_routes_container.show()
	add_button.disabled = false
	display_routes()
	folder_selected.emit(directory)


func _on_search_box_text_changed(_new_text: String) -> void:
	display_routes()


func _on_add_button_pressed():
	route_name_dialog.activate()
	route_name_dialog.connect("name_selected", create_route)


func create_route(new_name: String) -> void:
	route_name_dialog.disconnect("name_selected", create_route)
	var route = Route.new()
	route.name = new_name
	route_mapper.create(route)
	routes.append(route)
	display_routes()
	new_route.emit(route)


func _on_rename_route(route: Route) -> void:
	route_name_dialog.activate(route.name)
	route_name_dialog.connect("name_selected", rename_route.bind(route))


func rename_route(new_name: String, route: Route) -> void:
	route_name_dialog.disconnect("name_selected", rename_route)
	route_renamed.emit(route, new_name)
	route_mapper.delete(route.name)
	route.name = new_name
	route_mapper.create(route)
	display_routes()


func _on_duplicate_route(route: Route) -> void:
	route_name_dialog.activate("Copy of " + route.name)
	route_name_dialog.connect("name_selected", duplicate_route.bind(route))


func duplicate_route(new_name: String, route: Route) -> void:
	route_name_dialog.disconnect("name_selected", duplicate_route)
	var duplicated_route = Route.new()
	duplicated_route.name = new_name
	duplicated_route.trade_stops = route.trade_stops
	route_mapper.create(duplicated_route)
	routes.append(duplicated_route)
	display_routes()
	route_duplicated.emit(route, duplicated_route)


func _on_delete_route(route: Route) -> void:
	delete_confirmation_dialog.dialog_text = "Delete route " + route.name + "?"
	delete_confirmation_dialog.show()
	delete_confirmation_dialog.connect("confirmed", delete_route.bind(route))


func delete_route(route: Route) -> void:
	delete_confirmation_dialog.disconnect("confirmed", delete_route)
	route_mapper.delete(route.name)
	routes.erase(route)
	display_routes()
	route_deleted.emit(route)
