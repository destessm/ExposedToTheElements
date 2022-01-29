extends Node

export (PackedScene) var Mob
var score
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	new_game()

func _on_Player_killed():
	$MobTimer.stop()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$MobTimer.start()


func _on_MobTimer_timeout(): #probably keep track of how many mobs are on screen
#	print("mob timout")
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = rng.randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	mob.start(decide_which_mob_type(1))
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position

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
	print("score is " + str(score))
	pass # Replace with function body.
