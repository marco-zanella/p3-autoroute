extends VBoxContainer

signal created
signal set_default(pricing: Pricing)
signal selected(pricing: Pricing)
signal rename(pricing: Pricing)
signal deleted(pricing: Pricing)

@onready var pricing_container = %PricingContainer
var pricing_list_item_scene = preload("res://ui/Pricing/PricingListItem/PricingListItem.tscn")

func clear_pricings() -> void:
	for pricing_list_item in pricing_container.get_children():
		pricing_list_item.queue_free()


func display_pricings(pricings: Array[Pricing]) -> void:
	clear_pricings()
	for pricing in pricings:
		spawn_pricing(pricing)


func spawn_pricing(pricing: Pricing) -> void:
	var pricing_list_item = pricing_list_item_scene.instantiate()
	pricing_container.add_child(pricing_list_item)
	pricing_list_item.set_pricing(pricing)
	pricing_list_item.connect("set_default", func (item: Pricing) -> void: set_default.emit(item))
	pricing_list_item.connect("selected", func (item: Pricing) -> void: selected.emit(item))
	pricing_list_item.connect("rename", func (item: Pricing) -> void: rename.emit(item))
	pricing_list_item.connect("deleted", func (item: Pricing) -> void: deleted.emit(item))


func _on_add_button_pressed():
	created.emit()
