extends VBoxContainer

signal confirmed(route: Array[TradeStop])
signal cancelled

const MAX_STOPS = 20
@onready var town_option_button = %TownOptionButton
@onready var maximum_goods_spin_box = %MaximumGoodsSpinBox
@onready var good_list = %GoodList

func _ready() -> void:
	for town in TownRepository.Town.values():
		town_option_button.add_item(TownRepository.names[town], town)


func get_trade_stops() -> Array[TradeStop]:
	var town = town_option_button.selected
	var maximum_goods = maximum_goods_spin_box.value
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
	var last_bought_good = -1
	var last_enabled_good = -1
	var was_bought: Array[bool] = []
	was_bought.resize(GoodRepository.Type.size())
	was_bought.fill(false)
	for i in MAX_STOPS - 1:
		var buying_goods = 0
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
				if buying_goods < maximum_goods and good["good"] > last_bought_good and not was_bought[good["good"]]:
					rule.mode = Rule.Mode.BUY
					rule.quantity = -1
					rule.price = good["buying_price"]
					buying_goods += 1
					last_bought_good = good["good"]
					was_bought[good["good"]] = true
				else:
					rule.mode = Rule.Mode.DEPOSIT
					rule.quantity = -1
					rule.price = 1
					was_bought[good["good"]] = false
				last_enabled_good = good["good"]
			trade_stop.rules.append(rule)
		if last_bought_good == last_enabled_good:
			last_bought_good = -1
		trade_stops.append(trade_stop)
	
	return trade_stops


func _on_cancel_button_pressed() -> void:
	cancelled.emit()


func _on_confirm_button_pressed() -> void:
	confirmed.emit(get_trade_stops())
