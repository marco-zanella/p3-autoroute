extends VBoxContainer

signal saved(sorting: Sorting)

@onready var sorting_id_label = %SortingIdLabel
@onready var goods_container = %GoodsContainer
var good_list_item_scene = preload("res://ui/Sorting/GoodListItem/GoodListItem.tscn")
var sorting: Sorting

func set_sorting(new_sorting: Sorting) -> void:
	sorting = new_sorting
	sorting_id_label.text = new_sorting.id
	display_goods()


func display_goods() -> void:
	clear_goods()
	for good in sorting.goods:
		var good_list_item = good_list_item_scene.instantiate()
		good_list_item.visible = GoodRepository.visibility[good]
		goods_container.add_child(good_list_item)
		good_list_item.set_good(good)
		good_list_item.connect("move", _on_move)


func clear_goods() -> void:
	for good_list_item in goods_container.get_children():
		good_list_item.queue_free()


func _on_save_button_pressed() -> void:
	saved.emit(sorting)


func _on_move(original: GoodRepository.Type, target: GoodRepository.Type) -> void:
	var target_position = sorting.goods.find(target)
	sorting.goods.erase(original)
	sorting.goods.insert(target_position, original)
	display_goods()
