extends MenuBar

signal route_open
signal route_show
signal route_close
signal sorting_presets
signal price_presets
signal route_presets

func _on_routes_id_pressed(id: int) -> void:
	match id:
		0: route_open.emit()
		1: route_show.emit()
		2: route_close.emit()

func _on_prices_id_pressed(id: int) -> void:
	match id:
		0: sorting_presets.emit()
		1: price_presets.emit()
		2: route_presets.emit()
