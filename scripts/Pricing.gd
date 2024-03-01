extends Resource
class_name Pricing

@export var id: String
@export var is_default: bool = false
@export var buying: Array[int] = [
	130, 1000, 500, 50, 25, 120,
	200, 250, 280, 900, 100, 70,
	350, 280, 1000, 60, 900, 450,
	220, 80, 1, 1, 1, 1
]
@export var selling: Array[int] = [
	140, 1200, 550, 55, 30, 130,
	400, 360, 360, 1150, 140, 80,
	440, 330, 1200, 65, 1100, 600,
	260, 90, 1000, 1000, 1000, 1000
]
