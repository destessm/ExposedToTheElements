extends Area2D#RigidBody2D

class_name Mob

signal defeated

export (PackedScene) var mob_projectile
export (PackedScene) var mob_drop
#export var min_speed = 150  # Minimum speed range.
#export var max_speed = 250  # Maximum speed range.
export var min_timer = 1
export var max_timer = 2
var target_player
var element_type
var damage

const kill_sounds = [
	preload("res://Sounds/ghostkill_0.wav"),
	preload("res://Sounds/ghostkill_1.wav"),
	preload("res://Sounds/ghostkill_2.wav"),
	preload("res://Sounds/ghostkill_3.wav"),
]
const pew_sounds = [
	preload("res://Sounds/pew_0.wav"),
	preload("res://Sounds/pew_1.wav"),
	preload("res://Sounds/pew_2.wav"),
	preload("res://Sounds/pew_3.wav"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	target_player = get_parent().get_parent().find_node("Player")
	pass # Replace with function body.

func start(type):
	element_type = type
	damage = 10 #damage in case someone walks into the mob
	$AnimatedSprite.modulate = Elements.color[type]
	connect("defeated", get_node("/root/Main"), "_on_Mob_defeated")
	$FireTimer.wait_time = rand_range(min_timer, max_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Mob_body_entered(body):
#	print("_on_Mob_body_entered by " + body.name)
	if body is Projectile and body.element_type == Elements.type.NONE:
		body.destroy(true)
		destroy(true)
	pass # Replace with function body.

func destroy(defeated):
	drop()
	hide()
	if defeated:
		emit_signal("defeated")
		$AudioStreamPlayer.stream = kill_sounds[randi()%kill_sounds.size()]
		$AudioStreamPlayer.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$FireTimer.stop()
	if defeated:
		yield($AudioStreamPlayer, "finished")
	queue_free()

func drop():
	if target_player != null:
#		if element_type == Elements.type.FIRE or element_type == Elements.type.WATER:
#			if target_player.axis_fire_water != Elements.type.NONE:
#				return
#		elif element_type == Elements.type.AIR or element_type == Elements.type.EARTH:
#			if target_player.axis_air_earth != Elements.type.NONE:
#				return
		if element_type == target_player.axis_fire_water or element_type == target_player.axis_air_earth:
			return
	var drop = mob_drop.instance()
	get_parent().get_parent().get_node("Pickups").add_child(drop)
	drop.start(position, element_type)

func fire():
	var projectile = mob_projectile.instance()
	get_parent().get_parent().get_node("Projectiles").add_child(projectile)
	var to_player = target_player.position - position
	var projectile_start_pos = position + to_player.normalized() *35
	projectile.start(projectile_start_pos, to_player, 200, element_type, 1)
	$AudioStreamPlayer.stream = pew_sounds[randi()%pew_sounds.size()]
	$AudioStreamPlayer.play()

func _on_FireTimer_timeout():
	fire()
	$FireTimer.wait_time = rand_range(min_timer, max_timer)
	pass # Replace with function body.
