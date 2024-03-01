extends Object
class_name BitArray

var data: PackedByteArray = []

static func from_number(value: int, length: int = 8) -> BitArray:
	var bit_array = BitArray.new()
	for i in length:
		bit_array.append(value >> i & 0x01)
	return bit_array

static func from_byte_array(byte_array: PackedByteArray) -> BitArray:
	var bit_array = BitArray.new()
	for i in byte_array.size():
		for j in 8:
			bit_array.append(byte_array.decode_u8(i) >> j & 0x1)
	return bit_array

func size() -> int:
	return data.size()

func as_unsigned() -> int:
	var result = 0
	for i in size():
		result += get_bit(i) << i
	return result

func as_array() -> Array[int]:
	var result: Array[int] = []
	for i in size():
		result.push_back(get_bit(i))
	return result

func as_byte_array() -> PackedByteArray:
	var result: PackedByteArray = []
	var value = 0
	var shift = 0
	for i in size():
		value += get_bit(i) << shift
		shift += 1
		if shift == 8:
			result.append(value)
			value = 0
			shift = 0
	if value != 0:
		result.append(value)
	return result

func get_bit(offset: int) -> int:
	return data.decode_u8(offset)

func set_bit(offset: int, value: int) -> BitArray:
	data.encode_u8(offset, value & 0x1)
	return self

func append(value: int) -> BitArray:
	data.append(value & 0x1)
	return self

func concatenate(other: BitArray) -> BitArray:
	for i in other.size():
		append(other.get_bit(i))
	return self

func slice(offset: int, length: int) -> BitArray:
	var result = BitArray.new()
	result.data = data.slice(offset, offset + length)
	return result

func read_unsigned(offset: int, length: int) -> int:
	return slice(offset, length).as_unsigned()

func _to_string() -> String:
	return "[" + ", ".join(as_array()) + "]"
