extends HSplitContainer

signal status(text: String)

@export var pricing_manager: PricingManager
@onready var pricing_list = %PricingList
@onready var good_list = %GoodList
@onready var pricing_name_dialog = %PricingNameDialog

func _ready() -> void:
	pricing_list.display_pricings(pricing_manager.pricings)


func select_pricing(pricing: Pricing) -> void:
	good_list.set_pricing(pricing)
	good_list.show()


func create_pricing(id: String) -> void:
	_pricing_name_dialog_disconnect()
	var pricing = Pricing.new()
	pricing.id = id
	pricing_manager.pricings.append(pricing)
	pricing_manager.save_all()
	pricing_list.display_pricings(pricing_manager.pricings)
	select_pricing(pricing)
	status.emit("Pricing \"" + id + "\" created")


func rename_pricing(new_id: String, pricing: Pricing) -> void:
	_pricing_name_dialog_disconnect()
	var old_id = pricing.id
	pricing.id = new_id
	pricing_manager.delete(old_id)
	pricing_manager.save(pricing)
	pricing_list.display_pricings(pricing_manager.pricings)
	select_pricing(pricing)
	status.emit("Pricing \"" + old_id + "\" renamed to \"" + pricing.id + "\"")


func _pricing_name_dialog_disconnect() -> void:
	if pricing_name_dialog.selected.is_connected(create_pricing):
		pricing_name_dialog.selected.disconnect(create_pricing)
	if pricing_name_dialog.selected.is_connected(rename_pricing):
		pricing_name_dialog.selected.disconnect(rename_pricing)


func _on_pricing_created() -> void:
	pricing_name_dialog.activate()
	pricing_name_dialog.selected.connect(create_pricing)


func _on_pricing_set_default(pricing: Pricing) -> void:
	pricing_manager.set_default(pricing)
	pricing_manager.save_all()
	pricing_list.display_pricings(pricing_manager.pricings)
	status.emit("Pricing \"" + pricing.id + "\" set as default")


func _on_pricing_selected(pricing: Pricing) -> void:
	select_pricing(pricing)
	status.emit("Opening pricing \"" + pricing.id + "\"")


func _on_pricing_renamed(pricing: Pricing) -> void:
	pricing_name_dialog.activate(pricing.id)
	pricing_name_dialog.selected.connect(rename_pricing.bind(pricing))


func _on_pricing_deleted(pricing: Pricing) -> void:
	pricing_manager.pricings.erase(pricing)
	pricing_manager.delete(pricing.id)
	pricing_list.display_pricings(pricing_manager.pricings)
	pricing_list.display_pricings(pricing_manager.pricings)
	status.emit("Pricing \"" + pricing.id + "\" deleted")


func _on_good_saved(pricing: Pricing) -> void:
	pricing_manager.save(pricing)
	status.emit("Pricing \"" + pricing.id + "\" saved")
