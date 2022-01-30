extends RigidBody2D

class_name Projectile

var element_type
var damage

enum sound_names {
	PLINK,
	EXPLODE,
}
const mxr = {
	sound_names.PLINK : [0,1],
	sound_names.EXPLODE : [2,3,4,5],
}
const sounds = [
	preload("res://Sounds/plink_0.wav"),
	preload("res://Sounds/plink_1.wav"),
	preload("res://Sounds/hit_0.wav"),
	preload("res://Sounds/hit_1.wav"),
	preload("res://Sounds/hit_2.wav"),
	preload("res://Sounds/hit_3.wav"),
]

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
		play_sound(sound_names.EXPLODE)
	else:
		$AnimatedSprite.play("ignored")
		play_sound(sound_names.PLINK)
	yield($AnimatedSprite, "animation_finished")
	yield($AudioStreamPlayer,"finished") #?
	hide()
	queue_free()

func play_sound(name):
	var indices = mxr[name]
	indices.size()
	var stream = sounds[indices[randi()%indices.size()]]
	$AudioStreamPlayer.stream = stream
	$AudioStreamPlayer.play()
