extends PanelContainer

signal move(original: GoodRepository.Type, target: GoodRepository.Type)
@onready var good_name_label = %GoodNameLabel
@onready var preview_scene = preload("res://ui/Sorting/GoodListItem/GoodListItem.tscn")
var good: GoodRepository.Type

func set_good(new_good: GoodRepository.Type) -> void:
	good = new_good
	good_name_label.text = GoodRepository.names[good]


func _get_drag_data(_pos):
	var preview = Control.new()
	var p = preview_scene.instantiate()
	set_drag_preview(preview)
	preview.add_child(p)
	p.set_good(good)
	p.position.x = 0.5 * preview.size.x
	return good


func _can_drop_data(_pos, _data) -> bool:
	return true


func _drop_data(_pos, data) -> void:
	move.emit(data, good)
