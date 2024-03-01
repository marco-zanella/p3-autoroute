extends HSplitContainer

signal status(status: String)

@export var sorting_manager: SortingManager
@export var pricing_manager: PricingManager
@onready var route_list = %RouteList
@onready var route_info = %RouteInfo
@onready var rule_info = %RuleInfo

func select_folder() -> void:
	route_list._on_select_folder_pressed()


func close_folder() -> void:
	route_list.close()
	route_info.hide()
	rule_info.hide()
	status.emit("Working folder closed")


func _on_folder_selected(folder: String) -> void:
	route_info.hide()
	rule_info.hide()
	status.emit("Selected folder " + folder)


func _on_route_created(route: Route) -> void:
	status.emit("Created route " + route.name)


func _on_route_selected(route: Route) -> void:
	status.emit("Selected route " + route.name)
	route_info.set_route(route)
	route_info.show()
	rule_info.hide()


func _on_route_renamed(route: Route, new_name: String) -> void:
	status.emit("Route " + route.name + " renamed to " + new_name)


func _on_route_duplicated(route: Route, new_route: Route) -> void:
	status.emit("Route " + route.name + " copied into " + new_route.name)


func _on_route_deleted(route: Route) -> void:
	status.emit("Deleted route " + route.name)


func _on_route_saved(route: Route) -> void:
	status.emit("Route " + route.name + " saved")


func _on_route_info_applied_preset(route: Route) -> void:
	status.emit("Applied preset to route " + route.name)


func _on_trade_stop_selected(trade_stop: TradeStop) -> void:
	rule_info.show()
	rule_info.set_trade_stop(trade_stop)
	rule_info.set_sorting_presets(sorting_manager.sortings)
	rule_info.set_pricing_presets(pricing_manager.pricings)
	status.emit("Trade stop selected")


func _on_trade_stop_duplicated(_trade_stop) -> void:
	status.emit("Trade stop duplicated")


func _on_trade_stop_moved(_trade_stop, new_position: int) -> void:
	status.emit("Trade stop moved to position " + str(new_position + 1))


func _on_trade_stop_added():
	var trade_stop = TradeStop.new()
	for good in sorting_manager.get_default().goods:
		var rule = Rule.new()
		rule.good = good
		trade_stop.rules.append(rule)
	route_info.spawn_trade_stop(trade_stop)
	rule_info.show()
	rule_info.set_trade_stop(trade_stop)
	status.emit("Trade stop deleted")


func _on_trade_stop_deleted(_trade_stop) -> void:
	rule_info.hide()
	status.emit("Trade stop deleted")


func _on_rule_info_previous(trade_stop: TradeStop) -> void:
	route_info.select_previous_trade_stop(trade_stop)


func _on_rule_info_next(trade_stop: TradeStop) -> void:
	route_info.select_next_trade_stop(trade_stop)
