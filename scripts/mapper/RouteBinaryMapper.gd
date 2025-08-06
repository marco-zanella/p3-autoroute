extends Object
class_name RouteBinaryMapper

var path

func int_to_le_bytes(value: int) -> PackedByteArray:
	var arr := PackedByteArray()
	arr.resize(4)
	for i in range(4):
		arr[i] = (value >> (i * 8)) & 0xFF
	return arr

func create(route: Route) -> void:
	var output = PackedByteArray()
	output.resize(route.trade_stops.size() * 220)

	for i in range(route.trade_stops.size()):
		var stop = route.trade_stops[i]
		output.encode_u16(i * 220, 0x0)
		output.encode_u8(i * 220 + 0x2, stop.town)
		match stop.mode:
			TradeStop.Mode.DOCK:
				output.encode_u8(i * 220 + 0x3, 0)
			TradeStop.Mode.REPAIR:
				output.encode_u8(i * 220 + 0x3, 1)
			TradeStop.Mode.SKIP:
				output.encode_u8(i * 220 + 0x3, 9)

		for j in range(24):
			var rule = stop.rules[j]
			var price = 0
			var quantity = 0
			var size = GoodRepository.sizes[rule.good]
			match rule.mode:
				Rule.Mode.BUY:
					quantity = rule.quantity * size if rule.quantity != -1 else 1000000000
					price = -rule.price
				Rule.Mode.SELL:
					quantity = rule.quantity * size if rule.quantity != -1 else 1000000000
					price = rule.price
				Rule.Mode.WITHDRAW:
					quantity = rule.quantity * size if rule.quantity != -1 else 1000000000
				Rule.Mode.DEPOSIT:
					quantity = -rule.quantity * size if rule.quantity != -1 else -1000000000
			output.encode_u8(i * 220 + 0x4 + j, rule.good)
			output.encode_s32(i * 220 + 0x1C + rule.good * 4, price)
			output.encode_s32(i * 220 + 0x7C + rule.good * 4, quantity)
	var compressor = Compressor.new()
	var compressed = compressor.encode(output)

	# Write to .rou file
	var file_path = path + "/" + route.name + ".rou"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_buffer(compressed)
		file.close()
	else:
		push_error("Failed to create route file: " + file_path)

func read(route_name: String) -> Route:
	var file_path = path + "/" + route_name + ".rou"

	# Validate file
	if not FileAccess.file_exists(file_path):
		push_error("Route file not found: %s" % file_path)
		return Route.new()

	# Read and decompress
	var file = FileAccess.open(file_path, FileAccess.READ)
	var compressed_data = file.get_buffer(file.get_length())
	file.close()

	var compressor = Compressor.new()
	var decompressed_data = compressor.decode(compressed_data)
	var stream = StreamPeerBuffer.new()
	stream.data_array = decompressed_data
	stream.set_big_endian(false)  # Ensure little-endian decoding

	var route = Route.new()
	route.name = route_name

	var stop_count = abs(decompressed_data.size()) / 220
	for i in range(stop_count):
		var stop = TradeStop.new()

		# Read stop header
		stream.get_u16()  # skip 2-byte padding
		stop.town = stream.get_u8()
		var mode = stream.get_u8() & 0xB
		if mode == 0:
			stop.mode = TradeStop.Mode.DOCK
		elif mode == 1:
			stop.mode = TradeStop.Mode.REPAIR
		else:
			stop.mode = TradeStop.Mode.SKIP

		# Read goods order (24 bytes)
		var goods: Array[int] = []
		for j in range(24):
			goods.append(stream.get_u8())

		# Read prices (24 * 4 bytes)
		var prices: Array[int] = []
		for j in range(24):
			prices.append(stream.get_32())

		# Read quantities (24 * 4 bytes)
		var quantities: Array[int] = []
		for j in range(24):
			quantities.append(stream.get_32())

		# Build Rules
		for j in range(24):
			var rule = Rule.new()
			var good_id = goods[j]
			rule.good = good_id
			if quantities[good_id] == 0:
				rule.mode = Rule.Mode.NONE
			elif prices[good_id] == 0 and quantities[good_id] < 0:
				rule.mode = Rule.Mode.DEPOSIT
			elif prices[good_id] == 0 and quantities[good_id] > 0:
				rule.mode = Rule.Mode.WITHDRAW
			elif prices[good_id] < 0:
				rule.mode = Rule.Mode.BUY
			elif prices[good_id] > 0:
				rule.mode = Rule.Mode.SELL
			rule.price = abs(prices[good_id])
			rule.quantity = abs(quantities[good_id]) / GoodRepository.sizes[good_id]
			if abs(quantities[good_id]) == 1000000000:
				rule.quantity = -1
			stop.rules.append(rule)

		# Add stop to route
		route.trade_stops.append(stop)

	return route

func delete(route_name: String) -> void:
	var file_path = path + "/" + route_name + ".rou"
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)

func search() -> Array[Route]:
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Failed to open save directory: " + path)
		return []

	var routes: Array[Route] = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".rou"):
			var name = file_name.get_basename()
			var route = read(name)
			routes.append(route)
		file_name = dir.get_next()

	return routes
