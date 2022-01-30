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
	$AnimatedSprite.modulate = Elements.color[type]
	damage = dmg

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func destroy(dealt_damage):
	linear_velocity = Vector2(0,0)
	$CollisionShape2D.disabled = true
	if dealt_damage:
		$AnimatedSprite.play("explode")
	else:
		$AnimatedSprite.play("ignored")
	yield($AnimatedSprite, "animation_finished")
	hide()
	queue_free()
