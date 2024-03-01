extends VBoxContainer

signal add
signal selected(sorting: Sorting)
signal set_default(sorting: Sorting)
signal rename(sorting: Sorting)
signal deleted(sorting: Sorting)

@onready var sortings_container = %SortingsContainer
var sorting_list_item_scene = preload("res://ui/Sorting/SortingListItem/SortingListItem.tscn")

func clear_sortings() -> void:
	for sorting_list_item in sortings_container.get_children():
		sorting_list_item.queue_free()


func display_sortings(sortings: Array[Sorting]) -> void:
	clear_sortings()
	for sorting in sortings:
		var sorting_list_item = sorting_list_item_scene.instantiate()
		sortings_container.add_child(sorting_list_item)
		sorting_list_item.set_sorting(sorting)
		sorting_list_item.connect("selected", func (item: Sorting) -> void: selected.emit(item))
		sorting_list_item.connect("set_default", func (item: Sorting) -> void: set_default.emit(item))
		sorting_list_item.connect("rename", func (item: Sorting) -> void: rename.emit(item))
		sorting_list_item.connect("delete", func (item: Sorting) -> void: deleted.emit(item))


func _on_add_button_pressed():
	add.emit()
