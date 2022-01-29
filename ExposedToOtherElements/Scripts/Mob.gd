extends Area2D#RigidBody2D

class_name Mob

signal defeated

export (PackedScene) var mob_projectile
export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.

var target_player
var element_type
var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	target_player = get_parent().find_node("Player")
	pass # Replace with function body.

func start(type):
	element_type = type
	damage = 10 #damage in case someone walks into the mob
	match(type):
		Elements.type.FIRE:
			$AnimatedSprite.modulate = Color.crimson
		Elements.type.WATER:
			$AnimatedSprite.modulate = Color.aqua
		Elements.type.AIR:
			$AnimatedSprite.modulate = Color.gray
		Elements.type.EARTH:
			$AnimatedSprite.modulate = Color.chocolate

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Mob_body_entered(body):
#	print("_on_Mob_body_entered by " + body.name)
	if body is Projectile and body.element_type == Elements.type.NONE:
		body.destroy()
		destroy(true)
	pass # Replace with function body.

func destroy(defeated):
	hide()
	emit_signal("defeated")
	$CollisionShape2D.set_deferred("disabled", true)
	$FireTimer.stop()

func fire():
	var projectile = mob_projectile.instance()
	get_parent().add_child(projectile)
	var to_player = target_player.position - position
	var projectile_start_pos = position + to_player.normalized() *35
	projectile.start(projectile_start_pos, to_player, 200, element_type, 5)

func _on_FireTimer_timeout():
	fire()
	pass # Replace with function body.
