extends PanelContainer

signal move(original, target)

@onready var good_label = %GoodLabel
@onready var mode_button = %ModeButton
@onready var price_box = %PriceBox
@onready var quantity_box = %QuantityBox
@onready var preview_scene = preload("res://ui/RuleItem/RuleItem.tscn")
var rule: Rule


func set_rule(new_rule: Rule) -> void:
	rule = new_rule
	good_label.text = GoodRepository.names[rule.good]
	mode_button.selected = rule.mode
	price_box.value = rule.price
	quantity_box.value = rule.quantity


func set_mode(new_mode: Rule.Mode) -> void:
	mode_button.selected = new_mode
	rule.mode = new_mode


func set_quantity(new_quantity: int) -> void:
	quantity_box.value = new_quantity
	rule.quantity = new_quantity


func _get_drag_data(_pos):
	var preview = Control.new()
	var p = preview_scene.instantiate()
	set_drag_preview(preview)
	preview.add_child(p)
	p.set_rule(rule)
	p.position.x = 0.5 * preview.size.x
	return self


func _can_drop_data(_pos, _data) -> bool:
	return true


func _drop_data(_pos, data) -> void:
	move.emit(data, self)


func _on_mode_button_item_selected(index: Rule.Mode) -> void:
	rule.mode = index


func _on_price_box_value_changed(value: int) -> void:
	rule.price = value


func _on_quantity_box_value_changed(value: int) -> void:
	rule.quantity = value
