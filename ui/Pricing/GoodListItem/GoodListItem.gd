extends PanelContainer

signal changed(good: GoodRepository.Type, buying_price: int, selling_price: int)

@onready var good_name_label = %GoodNameLabel
@onready var buying_spin_box = %BuyingSpinBox
@onready var selling_spin_box = %SellingSpinBox
var good: GoodRepository.Type

func set_good(new_good: GoodRepository.Type, buying_price: int, selling_price: int):
	good = new_good
	good_name_label.text = GoodRepository.names[new_good]
	buying_spin_box.value = buying_price
	selling_spin_box.value = selling_price


func _on_buying_spin_box_value_changed(value: int) -> void:
	changed.emit(good, value, selling_spin_box.value)


func _on_selling_spin_box_value_changed(value: int) -> void:
	changed.emit(good, buying_spin_box.value, value)
