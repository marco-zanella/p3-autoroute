extends Node
class_name PricingManager

const default_pricings_paths = [
	"res://assets/pricings/default.tres"
]
const custom_pricings_path = "user://pricings"

var pricings: Array[Pricing] = []

func _init():
	load_custom_pricings()
	if pricings.is_empty():
		load_default_pricings()


func load_default_pricings() -> void:
	for path in default_pricings_paths:
		pricings.append(ResourceLoader.load(path))


func load_custom_pricings() -> void:
	var directory = DirAccess.open(custom_pricings_path)
	if not directory:
		DirAccess.make_dir_absolute(custom_pricings_path)
		directory = DirAccess.open(custom_pricings_path)
	directory.list_dir_begin()
	var file_name = directory.get_next()
	while file_name != "":
		if not directory.current_is_dir() and file_name.ends_with(".tres"):
			var file_path = custom_pricings_path + "/" + file_name
			pricings.append(ResourceLoader.load(file_path))
		file_name = directory.get_next()


func save(pricing: Pricing) -> void:
	var file_path = custom_pricings_path + "/" + pricing.id + ".tres"
	ResourceSaver.save(pricing, file_path)


func save_all() -> void:
	for pricing in pricings:
		save(pricing)


func find(id: String) -> Pricing:
	for pricing in pricings:
		if pricing.id == id:
			return pricing
	return null


func delete(id: String) -> void:
	var file_path = custom_pricings_path + "/" + id + ".tres"
	DirAccess.remove_absolute(file_path)


func get_default() -> Pricing:
	for pricing in pricings:
		if pricing.is_default:
			return pricing
	return pricings[0]


func set_default(pricing: Pricing) -> void:
	pricing.is_default = true
	for other_pricing in pricings:
		if pricing != other_pricing:
			other_pricing.is_default = false
