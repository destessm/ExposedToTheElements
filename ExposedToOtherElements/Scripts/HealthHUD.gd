extends CanvasLayer

enum heart {
	FULL,
	HALF,
	EMPTY,
}
var heart_paths = [
	preload("res://Sprites/1bitpack_kenney_1.2/1bitpack_monochrome_transparent_tiles/tile532.png"),
	preload("res://Sprites/1bitpack_kenney_1.2/1bitpack_monochrome_transparent_tiles/tile531.png"),
	preload("res://Sprites/1bitpack_kenney_1.2/1bitpack_monochrome_transparent_tiles/tile530.png"),
]
var hearts

func _ready():
	hearts = []
	hearts.append($HeartTexture)
	hearts.append($HeartTexture2)
	hearts.append($HeartTexture3)
	hearts.append($HeartTexture4)
	hearts.append($HeartTexture5)
	hearts.append($HeartTexture6)
	hearts.append($HeartTexture7)
	hearts.append($HeartTexture8)
	hearts.append($HeartTexture9)
	hearts.append($HeartTexture10)
	pass # Replace with function body.

func set_heart_number(idx, val):
	var heart_texture
	match val:
		heart.FULL:
			heart_texture = heart_paths[0]
		heart.HALF:
			heart_texture = heart_paths[1]
		heart.EMPTY:
			heart_texture = heart_paths[2]
	hearts[idx].texture = heart_texture

func set_health_hearts(health):
	var num_full_hearts = health / 2
	var uses_half_heart = health % 2
	for i in range(num_full_hearts):
		set_heart_number(i, heart.FULL)
	if uses_half_heart == 0:
		for i in range(num_full_hearts, 10):
			set_heart_number(i, heart.EMPTY)
	else:
		set_heart_number(num_full_hearts, heart.HALF)
		for i in range(num_full_hearts+1, 10):
			set_heart_number(i, heart.EMPTY)

func _on_Player_player_health(value):
	set_health_hearts(value)
