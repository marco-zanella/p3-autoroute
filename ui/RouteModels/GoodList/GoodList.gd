extends ScrollContainer

@export var show_quantity: bool = false
@export var show_buying_price: bool = false
@export var show_selling_price: bool = false
@onready var goods_container = %GoodsContainer
var good_list_item_scene = preload("res://ui/RouteModels/GoodListItem/GoodListItem.tscn")

func _ready() -> void:
	for good in GoodRepository.Type.values():
		var good_list_item = good_list_item_scene.instantiate()
		good_list_item.good = good
		good_list_item.show_quantity = show_quantity
		good_list_item.show_buying_price = show_buying_price
		good_list_item.show_selling_price = show_selling_price
		goods_container.add_child(good_list_item)


func get_data() -> Array[Dictionary]:
	var data: Array[Dictionary] = []
	for good_list_item in goods_container.get_children():
		data.append({
			"good": good_list_item.get_good(),
			"enabled": good_list_item.is_enabled(),
			"quantity": good_list_item.get_quantity(),
			"buying_price": good_list_item.get_buying_price(),
			"selling_price": good_list_item.get_selling_price()
		})
	return data
