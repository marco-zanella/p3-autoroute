extends Resource
class_name Rule

enum Mode {NONE, BUY, SELL, WITHDRAW, DEPOSIT}

@export var good: GoodRepository.Type
@export var mode: Mode
@export_range(-1, 9999) var quantity: int = 0
@export_range(0, 9999) var price: int = 0
