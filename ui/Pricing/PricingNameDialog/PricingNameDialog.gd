extends Window

signal selected(new_id: String)
signal cancelled

@onready var value_edit = %ValueEdit

func set_initial_value(initial_value: String) -> void:
	value_edit.text = initial_value


func activate(initial_value: String = "") -> void:
	set_initial_value(initial_value)
	show()


func _on_cancel() -> void:
	cancelled.emit()
	hide()


func _on_confirm() -> void:
	selected.emit(value_edit.text)
	set_initial_value("")
	hide()
