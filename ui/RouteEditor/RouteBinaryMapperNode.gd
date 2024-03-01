extends Node
class_name RouteBinaryMapperNode

var route_mapper: RouteBinaryMapper = RouteBinaryMapper.new()

func set_path(path: String) -> void:
	route_mapper.path = path


func create(route: Route) -> void:
	route_mapper.create(route)


func read(route_name: String) -> Route:
	return route_mapper.read(route_name)


func delete(route_name: String) -> void:
	return route_mapper.delete(route_name)


func search() -> Array[Route]:
	return route_mapper.search()
