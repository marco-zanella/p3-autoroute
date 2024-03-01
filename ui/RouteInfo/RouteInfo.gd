extends VBoxContainer

signal route_saved(route: Route)
signal applied_preset(route: Route)
signal trade_stop_add()
signal trade_stop_selected(trade_stop: TradeStop)
signal trade_stop_duplicated(trade_stop: TradeStop)
signal trade_stop_moved(trade_stop: TradeStop, position: int)
signal trade_stop_deleted(trade_stop: TradeStop)

const MAX_STOPS = 20

@export var data_mapper: RouteBinaryMapperNode
@onready var name_label = %NameLabel
@onready var save_button = %SaveButton
@onready var presets_button = %PresetsButton
@onready var trade_stops_container = %TradeStopsContainer
@onready var add_button = %AddButton
@onready var route_preset_window = %RoutePresetWindow
var trade_stop_scene = preload("res://ui/TradeStop/TradeStop.tscn")
var route: Route

func set_route(new_route: Route) -> void:
	route = new_route
	name_label.text = new_route.name.replace(".rou", "")
	clear_trade_stops()
	for trade_stop in new_route.trade_stops:
		spawn_trade_stop(trade_stop)


func clear_trade_stops() -> void:
	for child in trade_stops_container.get_children():
		child.queue_free()
	
	
func spawn_trade_stop(trade_stop: TradeStop) -> void:
	var trade_stop_item = trade_stop_scene.instantiate()
	trade_stops_container.add_child(trade_stop_item)
	trade_stop_item.set_trade_stop(trade_stop)
	trade_stop_item.connect("selected", _on_selected)
	trade_stop_item.connect("move", _on_move)
	trade_stop_item.connect("duplicate", _on_duplicate)
	trade_stop_item.connect("delete", _on_delete)


func select_previous_trade_stop(trade_stop: TradeStop) -> void:
	var index = route.trade_stops.find(trade_stop)
	if index > 0:
		trade_stop_selected.emit(route.trade_stops[index - 1])


func select_next_trade_stop(trade_stop: TradeStop) -> void:
	var index = route.trade_stops.find(trade_stop)
	if index < route.trade_stops.size() - 1:
		trade_stop_selected.emit(route.trade_stops[index + 1])


func _on_selected(trade_stop: TradeStop) -> void:
	trade_stop_selected.emit(trade_stop)


func _on_move(original, target) -> void:
	var target_position = 0
	for child in trade_stops_container.get_children():
		if child == target:
			break
		target_position += 1
	trade_stops_container.move_child(original, target_position)
	trade_stop_moved.emit(original, target_position)


func _on_duplicate(trade_stop) -> void:
	if trade_stops_container.get_child_count() >= MAX_STOPS:
		return
	spawn_trade_stop(trade_stop.trade_stop)
	trade_stop_duplicated.emit(trade_stop)


func _on_delete(trade_stop) -> void:
	trade_stop.queue_free()
	trade_stop_deleted.emit(trade_stop)


func _on_add_button_pressed() -> void:
	if trade_stops_container.get_child_count() >= MAX_STOPS:
		return
	trade_stop_add.emit()


func _on_save_button_pressed() -> void:
	route.trade_stops = []
	for trade_stop_item in trade_stops_container.get_children():
		route.trade_stops.append(trade_stop_item.trade_stop)
	data_mapper.create(route)
	route_saved.emit(route)


func _on_presets_button_pressed() -> void:
	route_preset_window.show()


func _on_route_preset_window_confirmed(trade_stops: Array[TradeStop]) -> void:
	route.trade_stops = trade_stops
	clear_trade_stops()
	for trade_stop in trade_stops:
		spawn_trade_stop(trade_stop)
	trade_stop_selected.emit(trade_stops[0])
	applied_preset.emit(route)
