extends Object
class_name GoodRepository

enum Type {
	GRAIN, MEAT, FISH, BEER, SALT, HONEY,
	SPICES, WINE, CLOTH, SKINS, OIL, TIMBER,
	IRON_GOODS, LEATHER, WOOL, PITCH, PIG_IRON, HEMP,
	POTTERY, BRICKS, SWORD, BOW, CROSSBOW, CARBINE
}

enum Size {
	BARREL = 200,
	BUNDLE = 2000,
	WEAPON = 10
}

const names = [
	"Grain", "Meat", "Fish", "Beer", "Salt", "Honey",
	"Spices", "Wine", "Cloth", "Skins", "Oil", "Timber",
	"Iron Goods", "Leather", "Wool", "Pitch", "Pig Iron", "Hemp",
	"Pottery", "Bricks", "Sword", "Bow", "Crossbow", "Carbine"
]

const visibility = [
	true, true, true, true, true, true,
	true, true, true, true, true, true,
	true, true, true, true, true, true,
	true, true, false, false, false, false
]

const sizes = [
	Size.BUNDLE, Size.BUNDLE, Size.BUNDLE, Size.BARREL, Size.BARREL, Size.BARREL,
	Size.BARREL, Size.BARREL, Size.BARREL, Size.BARREL, Size.BARREL, Size.BUNDLE,
	Size.BARREL, Size.BARREL, Size.BUNDLE, Size.BARREL, Size.BUNDLE, Size.BUNDLE,
	Size.BARREL, Size.BUNDLE, Size.WEAPON, Size.WEAPON, Size.WEAPON, Size.WEAPON
]
