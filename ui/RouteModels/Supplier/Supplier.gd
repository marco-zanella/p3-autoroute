extends VBoxContainer

signal confirmed(route: Array[TradeStop])
signal cancelled

@onready var first_town_option_button = %FirstTownOptionButton
@onready var first_town_good_list = %FirstTownGoodList
@onready var second_town_option_button = %SecondTownOptionButton
@onready var second_town_good_list = %SecondTownGoodList

func _ready() -> void:
	for town in TownRepository.Town.values():
		first_town_option_button.add_item(TownRepository.names[town], town)
		second_town_option_button.add_item(TownRepository.names[town], town)


func get_trade_stops() -> Array[TradeStop]:
	var first_town = first_town_option_button.selected
	var second_town = second_town_option_button.selected
	var trade_stops: Array[TradeStop] = []
	
	# First trade stop set to skip to avoid notifications
	var trade_stop = TradeStop.new()
	trade_stop.town = (first_town + 1) % TownRepository.Town.size()
	trade_stop.mode = TradeStop.Mode.SKIP
	trade_stop.rules = _empty_rules()
	trade_stops.append(trade_stop)
	
	# Use first town for repairs
	trade_stop = TradeStop.new()
	trade_stop.town = first_town
	trade_stop.mode = TradeStop.Mode.REPAIR
	trade_stop.rules = _empty_rules()
	trade_stops.append(trade_stop)
	
	# Deposit goods and surplus to first town
	trade_stop = TradeStop.new()
	trade_stop.town = first_town
	trade_stop.mode = TradeStop.Mode.DOCK
	trade_stop.rules = _empty_rules()
	for good in first_town_good_list.get_data():
		if good["enabled"]:
			trade_stop.rules[good["good"]].mode = Rule.Mode.DEPOSIT
			trade_stop.rules[good["good"]].quantity = -1
	for good in second_town_good_list.get_data():
		if good["enabled"]:
			trade_stop.rules[good["good"]].mode = Rule.Mode.DEPOSIT
			trade_stop.rules[good["good"]].quantity = -1
	trade_stops.append(trade_stop)
	
	# Withdraw goods from first town
	trade_stop = TradeStop.new()
	trade_stop.town = first_town
	trade_stop.mode = TradeStop.Mode.DOCK
	trade_stop.rules = _empty_rules()
	for good in first_town_good_list.get_data():
		if good["enabled"]:
			trade_stop.rules[good["good"]].mode = Rule.Mode.WITHDRAW
			trade_stop.rules[good["good"]].quantity = good["quantity"]
	trade_stops.append(trade_stop)
	
	# Withdraw surplus from second town
	trade_stop = TradeStop.new()
	trade_stop.town = second_town
	trade_stop.mode = TradeStop.Mode.DOCK
	trade_stop.rules = _empty_rules()
	for good in first_town_good_list.get_data():
		if good["enabled"]:
			trade_stop.rules[good["good"]].mode = Rule.Mode.WITHDRAW
			trade_stop.rules[good["good"]].quantity = -1
	trade_stops.append(trade_stop)
	
	# Deposit goods to second town
	trade_stop = TradeStop.new()
	trade_stop.town = second_town
	trade_stop.mode = TradeStop.Mode.DOCK
	trade_stop.rules = _empty_rules()
	for good in first_town_good_list.get_data():
		if good["enabled"]:
			trade_stop.rules[good["good"]].mode = Rule.Mode.DEPOSIT
			trade_stop.rules[good["good"]].quantity = good["quantity"]
	trade_stops.append(trade_stop)
	
	# Withdraw goods from second town
	trade_stop = TradeStop.new()
	trade_stop.town = second_town
	trade_stop.mode = TradeStop.Mode.DOCK
	trade_stop.rules = _empty_rules()
	for good in second_town_good_list.get_data():
		if good["enabled"]:
			trade_stop.rules[good["good"]].mode = Rule.Mode.WITHDRAW
			trade_stop.rules[good["good"]].quantity = good["quantity"]
	trade_stops.append(trade_stop)
	
	return trade_stops


func _empty_rules() -> Array[Rule]:
	var rules: Array[Rule] = []
	for good in GoodRepository.Type.values():
		var rule = Rule.new()
		rule.good = good
		rule.mode = Rule.Mode.NONE
		rule.quantity = 0
		rules.append(rule)
	return rules


func _on_cancel_button_pressed() -> void:
	cancelled.emit()


func _on_confirm_button_pressed() -> void:
	confirmed.emit(get_trade_stops())
