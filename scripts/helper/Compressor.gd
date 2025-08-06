extends Object
class_name Compressor

const decompress_table = [
	{"field_0": 1, "field_4": 0x00},
	{"field_0": 2, "field_4": 0x02},
	{"field_0": 3, "field_4": 0x06},
	{"field_0": 4, "field_4": 0x0e},
	{"field_0": 5, "field_4": 0x1e},
	{"field_0": 6, "field_4": 0x3e},
	{"field_0": 7, "field_4": 0x7e},
	{"field_0": 8, "field_4": 0xfe}
]
const bitmask_table_1 = [0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff]
const bitmask_table_2 = [
	0x00,
	0x01,
	0x03,
	0x07,
	0x0f,
	0x1f,
	0x3f,
	0x7f,
	0xff,
	0x1ff,
	0x3ff,
	0x7ff,
	0xfff,
	0x1ff,
	0x3fff,
	0x7fff,
	0xffff,
	0x1_ffff,
	0x3_ffff,
	0x7_ffff,
	0xf_ffff,
	0x1f_ffff,
	0x3f_ffff,
	0x7f_ffff,
	0xff_ffff,
	0x1ff_ffff,
	0x3ff_ffff,
	0x7ff_ffff,
	0xfff_ffff,
	0x1fff_ffff,
	0x3FFFFFFF,
	0x7FFFFFFF,
]

func encode(data: PackedByteArray) -> PackedByteArray:
	var bit_array = BitArray.new()
	bit_array.concatenate(BitArray.from_number(data.size(), 32))
	for i in data.size():
		bit_array.append(0)
		bit_array.concatenate(BitArray.from_number(data.decode_u8(i)))
	return bit_array.as_byte_array()

func decode(data: PackedByteArray) -> PackedByteArray:
	var reader = BitReader.from_bit_array(BitArray.from_byte_array(data))
	var length = reader.read_unsigned(32)
	var output: PackedByteArray = []
	while output.size() < length:
		# Reads compressed data
		if reader.read_unsigned(1) == 1:
			var compressed_chunk_type = reader.read_unsigned(3)
			var compressed_chunk_length = decompress_table[compressed_chunk_type].field_0
			var compressed_chunk = reader.read_unsigned(compressed_chunk_length)
			var negated_value = decompress_table[compressed_chunk_type].field_4 + (bitmask_table_1[compressed_chunk_type] & compressed_chunk)
			var offset = ~negated_value
			var elements = 1
			var output_elements = 2
			while true:
				elements += 1
				var compressed_data = reader.read_unsigned(elements)
				var compressed_elements = bitmask_table_1[elements] & compressed_data
				output_elements += compressed_elements
				if compressed_elements != bitmask_table_2[elements]:
					break
			var repeated_value_index = output.size() + offset
			for i in output_elements:
				var value = output.decode_u8(repeated_value_index + i)
				output.append(value)
		# Reads uncompressed data
		else:
			var value = reader.read_unsigned(8)
			output.append(value)
	return output
