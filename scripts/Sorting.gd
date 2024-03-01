extends Resource
class_name Sorting

@export var id: String
@export var is_default: bool = false
@export var goods: Array[GoodRepository.Type] = [
	GoodRepository.Type.GRAIN,
	GoodRepository.Type.MEAT,
	GoodRepository.Type.FISH,
	GoodRepository.Type.BEER,
	GoodRepository.Type.SALT,
	GoodRepository.Type.HONEY,
	GoodRepository.Type.SPICES,
	GoodRepository.Type.WINE,
	GoodRepository.Type.CLOTH,
	GoodRepository.Type.SKINS,
	GoodRepository.Type.OIL,
	GoodRepository.Type.TIMBER,
	GoodRepository.Type.IRON_GOODS,
	GoodRepository.Type.LEATHER,
	GoodRepository.Type.WOOL,
	GoodRepository.Type.PITCH,
	GoodRepository.Type.PIG_IRON,
	GoodRepository.Type.HEMP,
	GoodRepository.Type.POTTERY,
	GoodRepository.Type.BRICKS,
	GoodRepository.Type.SWORD,
	GoodRepository.Type.BOW,
	GoodRepository.Type.CROSSBOW,
	GoodRepository.Type.CARBINE
]
