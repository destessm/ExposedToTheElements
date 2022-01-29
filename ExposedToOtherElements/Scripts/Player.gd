extends Area2D

signal killed

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

export var starting_health = 100
var health
var axis_fire_water
var axis_air_earth

func _ready():
	screen_size = get_viewport_rect().size
#	start()

func start(pos):
	position = pos
	health = starting_health
	axis_fire_water  = Elements.type.NONE
	axis_air_earth = Elements.type.NONE
	$CollisionShape2D.disabled = false

func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(body):
	# something about damage here probably
	pass # Replace with function body.

func flip_axes():
	if axis_fire_water != Elements.type.NONE:
		if axis_fire_water == Elements.type.FIRE:
			axis_fire_water = Elements.type.WATER
		else:
			axis_fire_water = Elements.type.FIRE
	if axis_air_earth != Elements.type.NONE:
		if axis_air_earth == Elements.type.AIR:
			axis_air_earth = Elements.type.EARTH
		else:
			axis_air_earth = Elements.type.AIR
