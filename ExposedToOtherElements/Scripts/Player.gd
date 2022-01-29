extends Area2D

signal killed

export var speed = 400  # How fast the player will move (pixels/sec).
export (PackedScene) var player_projectile
var screen_size  # Size of the game window.

export var starting_health = 100
var health
var axis_fire_water
var axis_air_earth
export var fire_interval_ms = 500 #ms
var can_fire
var time_last_fired
var immunities

func _ready():
	screen_size = get_viewport_rect().size
	can_fire = true
	time_last_fired = -1 * fire_interval_ms
#	start()

func start(pos):
	position = pos
	health = starting_health
	axis_fire_water  = Elements.type.NONE
	axis_air_earth = Elements.type.NONE
	$CollisionShape2D.disabled = false
	immunities = []

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
#	update()
#	look_at(get_global_mouse_position())
	$AimReticle.position = get_local_mouse_position()

func _on_Player_body_entered(body):
	# something about damage here probably
#	print("Player body entered by " + body.name)
	if (body is Projectile or body is Mob) and body.element_type != Elements.type.NONE:
		match body.element_type:
			Elements.type.FIRE:
				if axis_fire_water == Elements.type.FIRE:
					print("ignored fire damage")
				else:
					print("took fire damage")
					health -= body.damage
			Elements.type.WATER:
				if axis_fire_water == Elements.type.WATER:
					print("ignored water damage")
				else:
					print("took water damage")
					health -= body.damage
		if body is Projectile: 
			body.destroy()
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

func _input(event):
	if event is InputEventMouseButton and can_fire():
		$AimReticle.play("click")
		fire()

func can_fire():
	return OS.get_ticks_msec() > time_last_fired + fire_interval_ms

func fire():
	var projectile = player_projectile.instance()
	get_parent().add_child(projectile)
	var projectile_start_pos = position + get_local_mouse_position().normalized() *35
	projectile.start(projectile_start_pos, get_local_mouse_position(), 200, Elements.type.NONE, 5)
	can_fire = false
	time_last_fired = OS.get_ticks_msec()


func _on_AimReticle_animation_finished():
	if $AimReticle.animation == "click":
		$AimReticle.play("default")
#		print("set back to default")
