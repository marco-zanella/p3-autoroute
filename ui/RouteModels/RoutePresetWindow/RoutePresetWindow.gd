extends Window

signal confirmed(trade_stops: Array[TradeStop])
signal cancelled

@onready var tab_container = %TabContainer


func _on_preset_cancelled():
	cancelled.emit()
	hide()


func _on_preset_confirmed(trade_stops: Array[TradeStop]) -> void:
	confirmed.emit(trade_stops)
	hide()
