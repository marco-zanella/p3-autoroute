extends Control

@onready var status_label = $StatusLabel

func get_status() -> String:
	return status_label.text

func set_status(status: String) -> void:
	status_label.text = status

func clear() -> void:
	set_status("")
