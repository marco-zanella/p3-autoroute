extends VBoxContainer

signal previous(trade_stop: TradeStop)
signal next(trade_stop: TradeStop)

@onready var town_label = %TownLabel
@onready var rules_container = %RulesContainer
@onready var sort_button = %SortButton
@onready var price_presets_button = %PricePresetsButton
var rule_scene = preload("res://ui/RuleItem/RuleItem.tscn")
var trade_stop: TradeStop
var sorting_presets: Array[Sorting]
var pricing_presets: Array[Pricing]

func set_trade_stop(new_trade_stop: TradeStop) -> void:
	trade_stop = new_trade_stop
	town_label.text = TownRepository.names[trade_stop.town]
	display_rules()


func clear_rules() -> void:
	for child in rules_container.get_children():
		child.queue_free()


func display_rules() -> void:
	clear_rules()
	for rule in trade_stop.rules:
		spawn_rule(rule)


func spawn_rule(rule: Rule) -> void:
	var rule_item = rule_scene.instantiate()
	rule_item.visible = GoodRepository.visibility[rule.good]
	rules_container.add_child(rule_item)
	rule_item.set_rule(rule)
	rule_item.connect("move", _on_move)


func set_sorting_presets(sortings: Array[Sorting]) -> void:
	sorting_presets = sortings
	sort_button.clear()
	sort_button.add_separator("Sort")
	for i in sortings.size():
		sort_button.add_item(sortings[i].id, i)
		sort_button.set_item_metadata(i, sortings[i])


func set_pricing_presets(pricings: Array[Pricing]) -> void:
	pricing_presets = pricings
	price_presets_button.clear()
	price_presets_button.add_separator("Pricing")
	for i in pricings.size():
		price_presets_button.add_item(pricings[i].id, i)
		price_presets_button.set_item_metadata(i, pricings[i])


func _on_move(original, target) -> void:
	var target_position = 0
	for child in rules_container.get_children():
		if child == target:
			break
		target_position += 1
	rules_container.move_child(original, target_position)
	trade_stop.rules.erase(original.rule)
	trade_stop.rules.insert(target_position, original.rule)


func _on_previous_button_pressed():
	previous.emit(trade_stop)


func _on_next_button_pressed():
	next.emit(trade_stop)


func _on_quantity_button_item_selected(index: int) -> void:
	var new_quantity = 0
	match index:
		0: new_quantity = 0
		2: new_quantity = -1
	for rule_item in rules_container.get_children():
		rule_item.set_quantity(new_quantity)


func _on_mode_button_item_selected(index: Rule.Mode) -> void:
	for rule_item in rules_container.get_children():
		rule_item.set_mode(index)


func _on_sort_button_item_selected(index: int) -> void:
	var sorting: Sorting = sort_button.get_item_metadata(index - 1)
	trade_stop.rules.sort_custom(func (rule_a, rule_b): return sorting.goods.find(rule_a.good) < sorting.goods.find(rule_b.good))
	display_rules()


func _on_price_presets_button_item_selected(index: int) -> void:
	var pricing: Pricing = price_presets_button.get_item_metadata(index - 1)
	for rule in trade_stop.rules:
		if rule.mode == Rule.Mode.BUY:
			rule.price = pricing.buying[rule.good]
		elif rule.mode == Rule.Mode.SELL:
			rule.price = pricing.selling[rule.good]
	display_rules()
