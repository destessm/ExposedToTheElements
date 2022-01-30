extends Node

class_name Elements

enum type {
	NONE = 0,
	FIRE = 1,
	WATER = 2,
	AIR = 3,
	EARTH = 4,
}

const color = {
	type.NONE : Color.white,
	type.FIRE : Color.orangered,
	type.WATER : Color.aqua,
	type.AIR : Color.gray,
	type.EARTH : Color.olivedrab,
}

const names = {
	type.NONE : "NONE",
	type.FIRE : "FIRE",
	type.WATER : "WATER",
	type.AIR : "AIR",
	type.EARTH : "EARTH",
}
