extends PanelContainer

signal selected(sorting: Sorting)
signal set_default(sorting: Sorting)
signal rename(sorting: Sorting)
signal delete(sorting: Sorting)

@onready var id_label = %IdLabel
@onready var set_default_button = %SetDefaultButton
var sorting: Sorting

func set_sorting(new_sorting: Sorting) -> void:
	sorting = new_sorting
	id_label.text = sorting.id
	set_default_button.disabled = sorting.is_default


func _on_set_default_button_pressed():
	set_default.emit(sorting)


func _on_edit_button_pressed():
	selected.emit(sorting)


func _on_rename_button_pressed():
	rename.emit(sorting)


func _on_delete_button_pressed():
	delete.emit(sorting)
