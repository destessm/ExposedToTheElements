extends RigidBody2D

class_name Projectile

var element_type
var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	element_type = Elements.type.NONE
	show()
	$CollisionShape2D.disabled = false
	pass # Replace with function body.

func start(pos, dir, vel, type, dmg):
	position = pos
#	look_at(dir) #pos + dir?
#	rotation = dir ?
	linear_velocity = Vector2(vel, 0)
	linear_velocity = linear_velocity.rotated(dir.angle())
	element_type = type
	match(type):
		Elements.type.FIRE:
			$AnimatedSprite.modulate = Color.crimson
		Elements.type.WATER:
			$AnimatedSprite.modulate = Color.aqua
		Elements.type.AIR:
			$AnimatedSprite.modulate = Color.gray
		Elements.type.EARTH:
			$AnimatedSprite.modulate = Color.chocolate
	damage = dmg

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func destroy():
	hide()
	$CollisionShape2D.disabled
	queue_free()
