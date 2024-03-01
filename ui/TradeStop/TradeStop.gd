extends PanelContainer

signal selected(trade_stop: TradeStop)
signal move(original: PanelContainer, target: PanelContainer)
signal duplicate(trade_stop: PanelContainer)
signal delete(trade_stop: PanelContainer)

@onready var town_button = %TownButton
@onready var mode_button = %ModeButton
@onready var context_menu = %ContextMenu
@onready var preview_scene = preload("res://ui/TradeStop/TradeStop.tscn")
var trade_stop: TradeStop

func _ready():
	for town in TownRepository.names:
		town_button.add_item(town)


func set_trade_stop(new_trade_stop: TradeStop) -> void:
	trade_stop = new_trade_stop
	town_button.selected = trade_stop.town
	mode_button.selected = trade_stop.mode


func _get_drag_data(_pos):
	var preview = Control.new()
	var p = preview_scene.instantiate()
	set_drag_preview(preview)
	preview.add_child(p)
	p.set_trade_stop(trade_stop)
	p.position.x = 0.5 * preview.size.x
	return self


func _can_drop_data(_pos, _data) -> bool:
	return true


func _drop_data(_pos, data) -> void:
	move.emit(data, self)


func _on_town_button_item_selected(index: TownRepository.Town) -> void:
	trade_stop.town = index
	selected.emit(trade_stop)


func _on_mode_button_item_selected(index: TradeStop.Mode) -> void:
	trade_stop.mode = index


func _on_gui_input(event) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			selected.emit(trade_stop)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			context_menu.show()
			context_menu.position = get_global_mouse_position()


func _on_context_menu_id_pressed(id: int) -> void:
	match id:
		0: selected.emit(trade_stop)
		1: duplicate.emit(self)
		2: delete.emit(self)


func _on_edit_button_pressed() -> void:
	selected.emit(trade_stop)


func _on_delete_button_pressed() -> void:
	delete.emit(self)
