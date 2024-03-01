extends Resource
class_name TradeStop

enum Mode {DOCK, REPAIR, SKIP}

@export var town: TownRepository.Town
@export var mode: Mode
@export var rules: Array[Rule]
