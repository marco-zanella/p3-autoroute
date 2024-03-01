extends VBoxContainer

signal confirmed(route: Array[TradeStop])
signal cancelled

const MAX_STOPS = 20
@onready var town_option_button = %TownOptionButton
@onready var good_list = %GoodList

func _ready() -> void:
	for town in TownRepository.Town.values():
		town_option_button.add_item(TownRepository.names[town], town)


func get_trade_stops() -> Array[TradeStop]:
	var town = town_option_button.selected
	var trade_stops: Array[TradeStop] = []
	
	# First trade stop set to skip to avoid notifications
	var first_trade_stop = TradeStop.new()
	first_trade_stop.town = (town + 1) % TownRepository.Town.size()
	first_trade_stop.mode = TradeStop.Mode.SKIP
	for good in GoodRepository.Type.values():
		var rule = Rule.new()
		rule.good = good
		rule.mode = Rule.Mode.NONE
		rule.quantity = 0
		first_trade_stop.rules.append(rule)
	trade_stops.append(first_trade_stop)
	
	# Generates copies of the actual trade stop
	for i in MAX_STOPS - 1:
		var good_counter = 0
		var trade_stop = TradeStop.new()
		trade_stop.town = town
		trade_stop.mode = TradeStop.Mode.DOCK
		for good in good_list.get_data():
			var rule = Rule.new()
			rule.good = good["good"]
			rule.mode = Rule.Mode.NONE
			rule.quantity = 0
			rule.price = 1
			if good["enabled"]:
				if good_counter % 3 == i % 3:
					rule.mode = Rule.Mode.WITHDRAW
					rule.quantity = -1
					rule.price = 1
				elif (good_counter + 1) % 3 == i % 3:
					rule.mode = Rule.Mode.SELL
					rule.quantity = -1
					rule.price = good["selling_price"]
				else:
					rule.mode = Rule.Mode.DEPOSIT
					rule.quantity = -1
					rule.price = 1
				good_counter += 1
			trade_stop.rules.append(rule)
		trade_stops.append(trade_stop)
	
	return trade_stops


func _on_cancel_button_pressed() -> void:
	cancelled.emit()


func _on_confirm_button_pressed() -> void:
	confirmed.emit(get_trade_stops())
