extends Window

signal selected(new_name: String)
signal cancelled

@onready var line_edit = %LineEdit

func set_initial_name(initial_name: String) -> void:
	line_edit.text = initial_name

func activate(initial_name: String = "") -> void:
	set_initial_name(initial_name)
	show()


func _on_cancel_button_pressed():
	hide()
	cancelled.emit()


func _on_confirm_button_pressed():
	hide()
	selected.emit(line_edit.text)
	set_initial_name("")
