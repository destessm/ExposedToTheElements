extends RigidBody2D

signal defeated

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#on killed, signal defeated
