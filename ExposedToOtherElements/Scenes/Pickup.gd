extends Area2D

class_name Pickup

export var time_to_live = 2

var element_type
var can_be_picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	$NoticeSprite.hide()
	can_be_picked_up = false
	pass # Replace with function body.

func start(pos, type):
	position = pos
	element_type = type
	$AnimatedSprite.modulate = Elements.color[type]
	$Timer.start()

func _on_Pickup_area_shape_entered(area_id, area, area_shape, local_shape):
	print("something is near pickup")
	if area != null and area.name == "Player":
		print("player is near pickup!")
		$NoticeSprite.show()
		can_be_picked_up = true
	pass # Replace with function body.

func _on_Pickup_area_shape_exited(area_id, area, area_shape, local_shape):
	if area != null and area.name == "Player":
		$NoticeSprite.hide()
		can_be_picked_up = false
	pass # Replace with function body.

func _on_Timer_timeout():
	hide()
	can_be_picked_up = false
	queue_free()

func destroy(was_picked_up=false):
	can_be_picked_up = false
	$AudioStreamPlayer.play()
	hide()
	yield($AudioStreamPlayer, "finished")
	queue_free()
