extends HBoxContainer

signal status(message: String)

@export var sorting_manager: SortingManager
@onready var sorting_list = %SortingList
@onready var good_list = %GoodList
@onready var sorting_name_dialog = %SortingNameDialog

func _ready() -> void:
	sorting_list.display_sortings(sorting_manager.sortings)


func clear_connections() -> void:
	if sorting_name_dialog.is_connected("selected", add_sorting):
		sorting_name_dialog.disconnect("selected", add_sorting)
	if sorting_name_dialog.is_connected("selected", rename_sorting):
		sorting_name_dialog.disconnect("selected", rename_sorting)


func add_sorting(new_id: String) -> void:
	clear_connections()
	var sorting = Sorting.new()
	sorting.id = new_id
	sorting_manager.sortings.append(sorting)
	sorting_manager.save_all()
	sorting_list.display_sortings(sorting_manager.sortings)
	good_list.show()
	good_list.set_sorting(sorting)
	status.emit("Added sorting " + new_id)


func rename_sorting(new_id: String, sorting: Sorting) -> void:
	status.emit("Sorting " + sorting.id + " renamed to " + new_id)
	clear_connections()
	sorting_manager.delete(sorting.id)
	sorting.id = new_id
	sorting_manager.save_all()
	sorting_list.display_sortings(sorting_manager.sortings)
	good_list.set_sorting(sorting)


func _on_sorting_list_add_() -> void:
	sorting_name_dialog.activate()
	sorting_name_dialog.connect("selected", add_sorting)


func _on_sorting_list_set_default(sorting: Sorting) -> void:
	sorting_manager.set_default(sorting)
	sorting_manager.save_all()
	sorting_list.display_sortings(sorting_manager.sortings)
	status.emit("Sorting " + sorting.id + " set as default")


func _on_sorting_list_rename(sorting: Sorting) -> void:
	sorting_name_dialog.activate(sorting.id)
	sorting_name_dialog.connect("selected", rename_sorting.bind(sorting))


func _on_sorting_list_selected(sorting: Sorting) -> void:
	good_list.show()
	good_list.set_sorting(sorting)
	status.emit("Opening sorting " + sorting.id)


func _on_sorting_list_delete(sorting: Sorting) -> void:
	sorting_manager.sortings.erase(sorting)
	sorting_manager.delete(sorting.id)
	sorting_list.display_sortings(sorting_manager.sortings)
	good_list.hide()
	status.emit("Sorting " + sorting.id + " deleted")


func _on_good_list_saved(sorting: Sorting):
	sorting_manager.save(sorting)
	status.emit("Sorting " + sorting.id + " saved")
