extends Window

signal name_selected(name: String)
signal name_cancelled

@onready var name_edit = %NameEdit
@onready var cancel_button = %CancelButton
@onready var confirm_button = %ConfirmButton

func set_initial_name(initial_name: String) -> void:
	name_edit.text = initial_name
	

func activate(initial_name: String = "") -> void:
	set_initial_name(initial_name)
	show()


func _on_cancel_button_pressed() -> void:
	name_cancelled.emit()
	hide()


func _on_confirm_button_pressed() -> void:
	name_selected.emit(name_edit.text)
	name_edit.text = ""
	hide()
