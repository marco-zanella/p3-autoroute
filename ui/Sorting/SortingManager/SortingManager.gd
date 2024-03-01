extends Node
class_name SortingManager

const default_sortings_paths = [
	"res://assets/sortings/english.tres",
	"res://assets/sortings/internal.tres",
	"res://assets/sortings/italiano.tres"
]
const custom_sortings_path = "user://sortings"

var sortings: Array[Sorting] = []

func _init():
	load_custom_sortings()
	if sortings.is_empty():
		load_default_sortings()


func load_default_sortings() -> void:
	for path in default_sortings_paths:
		sortings.append(ResourceLoader.load(path))


func load_custom_sortings() -> void:
	var directory = DirAccess.open(custom_sortings_path)
	if not directory:
		DirAccess.make_dir_absolute(custom_sortings_path)
		directory = DirAccess.open(custom_sortings_path)
	directory.list_dir_begin()
	var file_name = directory.get_next()
	while file_name != "":
		if not directory.current_is_dir() and file_name.ends_with(".tres"):
			var file_path = custom_sortings_path + "/" + file_name
			sortings.append(ResourceLoader.load(file_path))
		file_name = directory.get_next()


func save(sorting: Sorting) -> void:
	var file_path = custom_sortings_path + "/" + sorting.id + ".tres"
	ResourceSaver.save(sorting, file_path)


func save_all() -> void:
	for sorting in sortings:
		save(sorting)


func find(id: String) -> Sorting:
	for sorting in sortings:
		if sorting.id == id:
			return sorting
	return null


func delete(id: String) -> void:
	var file_path = custom_sortings_path + "/" + id + ".tres"
	DirAccess.remove_absolute(file_path)


func get_default() -> Sorting:
	for sorting in sortings:
		if sorting.is_default:
			return sorting
	return sortings[0]


func set_default(sorting: Sorting) -> void:
	sorting.is_default = true
	for other_sorting in sortings:
		if sorting != other_sorting:
			other_sorting.is_default = false
