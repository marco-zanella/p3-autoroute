extends VBoxContainer

signal saved(pricing: Pricing)

@onready var pricing_id_label = %PricingIdLabel
@onready var goods_container = %GoodsContainer
var good_list_item_scene = preload("res://ui/Pricing/GoodListItem/GoodListItem.tscn")
var pricing: Pricing

func set_pricing(new_pricing: Pricing) -> void:
	pricing = new_pricing
	pricing_id_label.text = new_pricing.id
	display_goods()


func clear_goods() -> void:
	for good_list_item in goods_container.get_children():
		good_list_item.queue_free()


func display_goods() -> void:
	clear_goods()
	for good in GoodRepository.Type.values():
		var good_list_item = good_list_item_scene.instantiate()
		good_list_item.visible = GoodRepository.visibility[good]
		goods_container.add_child(good_list_item)
		good_list_item.set_good(good, pricing.buying[good], pricing.selling[good])
		good_list_item.changed.connect(_on_good_changed)


func _on_save_button_pressed() -> void:
	saved.emit(pricing)


func _on_good_changed(good: GoodRepository.Type, buying_price: int, selling_price: int) -> void:
	pricing.buying[good] = buying_price
	pricing.selling[good] = selling_price
