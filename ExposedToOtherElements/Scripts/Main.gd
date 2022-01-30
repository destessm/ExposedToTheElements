extends Node

signal score(value)

export (PackedScene) var Mob
export var score_to_advance = 10
var max_enemies = [6,10,14,18]
var score
var rng = RandomNumberGenerator.new()
var num_axes

func _ready():
	rng.randomize()
	new_game()

func _on_Player_killed():
	$MobTimer.stop()
	for pickup in $Pickups.get_children():
		pickup.destroy()
	for projectile in $Projectiles.get_children():
		projectile.destroy(false)
	for mob in $Mobs.get_children():
		mob.destroy(false)
	
func new_game():
	score = 0
	num_axes = 1
	$Player.start($StartPosition.position)
	$MobTimer.start()
	emit_signal("score", score)

#func _input(event):
#	if event.is_action("ui_accept"):
#		$MobPath/MobSpawnLocation.offset = rng.randi()
#		spawn_mob($MobPath/MobSpawnLocation.position, decide_which_mob_type(1))

func _on_MobTimer_timeout(): #probably keep track of how many mobs are on screen\
	var mob_count = $Mobs.get_child_count()
	print("num mobs counted: " + str(mob_count))
	var num_to_spawn = 1
	if mob_count > max_enemies[num_axes-1]:
		return
	if mob_count < max_enemies[num_axes-1]*0.5:
		num_to_spawn = 2
	if mob_count < max_enemies[num_axes-1]*0.25:
		num_to_spawn = 3
	for i in range(num_to_spawn):
		$MobPath/MobSpawnLocation.offset = rng.randi()
		var type = decide_which_mob_type(num_axes)
		spawn_mob($MobPath/MobSpawnLocation.position + $MobPath.position, type)

func spawn_mob(pos, type):
	var mob = Mob.instance()
	$Mobs.add_child(mob)
	mob.start(type)
	mob.position = pos

func decide_which_mob_type(num_axes):
	var max_elem = 2
	match num_axes:
		1:
			max_elem = 2
		2:
			max_elem = 4
#		3:
#			max_elem = 6
#		4:
#			max_elem = 8
	var num = rng.randi_range(1,max_elem)
	match num:
		1:
			return Elements.type.FIRE
		2:
			return Elements.type.WATER
		3:
			return Elements.type.AIR
		4:
			return Elements.type.EARTH

func _on_Mob_defeated():
	score += 1
	if score == score_to_advance:
		num_axes += 1
	emit_signal("score", score)
#	print("score is " + str(score))
