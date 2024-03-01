extends PanelContainer

signal set_default(pricing: Pricing)
signal selected(pricing: Pricing)
signal rename(pricing: Pricing)
signal deleted(pricing: Pricing)

@onready var id_label = %IdLabel
@onready var set_default_button = %SetDefaultButton
var pricing: Pricing

func set_pricing(new_pricing: Pricing) -> void:
	pricing = new_pricing
	id_label.text = new_pricing.id
	set_default_button.disabled = new_pricing.is_default


func _on_set_default_button_pressed() -> void:
	set_default.emit(pricing)


func _on_edit_button_pressed() -> void:
	selected.emit(pricing)


func _on_rename_button_pressed() -> void:
	rename.emit(pricing)


func _on_delete_button_pressed() -> void:
	deleted.emit(pricing)
