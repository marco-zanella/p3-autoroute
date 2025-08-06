extends Object
class_name BitReader

var data: BitArray
var position: int = 0

static func from_bit_array(bit_array: BitArray) -> BitReader:
	var bit_reader = BitReader.new()
	bit_reader.data = bit_array
	bit_reader.position = 0
	return bit_reader

func read_signed(size: int = 8) -> int:
	var value = data.read_unsigned(position, size)
	position += size
	
	var sign_bit = 1 << (size - 1)
	if value & sign_bit:
		value = value - (1 << size)
	return value

func read_unsigned(size: int = 8) -> int:
	var value = data.read_unsigned(position, size)
	position += size
	return value
