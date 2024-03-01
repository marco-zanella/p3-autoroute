extends PanelContainer

@export var good: GoodRepository.Type
@export var show_quantity: bool = false
@export var show_buying_price: bool = false
@export var show_selling_price: bool = false
@onready var good_check_box = %GoodCheckBox
@onready var quantity_spin_box = %QuantitySpinBox
@onready var buying_price_spin_box = %BuyingPriceSpinBox
@onready var selling_price_spin_box = %SellingPriceSpinBox

func _ready() -> void:
	good_check_box.text = GoodRepository.names[good]
	quantity_spin_box.visible = show_quantity
	buying_price_spin_box.visible = show_buying_price
	selling_price_spin_box.visible = show_selling_price


func get_good() -> GoodRepository.Type:
	return good


func is_enabled() -> bool:
	return good_check_box.button_pressed


func get_quantity() -> int:
	return quantity_spin_box.value


func get_buying_price() -> int:
	return buying_price_spin_box.value


func get_selling_price() -> int:
	return selling_price_spin_box.value


func _on_good_check_box_toggled(toggled_on: bool) -> void:
	quantity_spin_box.editable = toggled_on
	buying_price_spin_box.editable = toggled_on
	selling_price_spin_box.editable = toggled_on
