extends Area2D

signal killed
signal player_health(value)

export var speed = 400  # How fast the player will move (pixels/sec).
export (PackedScene) var player_projectile
var screen_size  # Size of the game window.

export var starting_health = 20
var health
var axis_fire_water
var axis_air_earth
export var fire_interval_ms = 500 #ms
var can_fire
var time_last_fired
var immunities
var can_move

func _ready():
	screen_size = get_viewport_rect().size
	can_fire = true
	time_last_fired = -1 * fire_interval_ms

func start(pos):
	can_move = true
	position = pos
	health = starting_health
	axis_fire_water  = Elements.type.NONE
	axis_air_earth = Elements.type.NONE
	$ElementShield_1.hide()
	$ElementShield_2.hide()
	$ElementShield_1.modulate = Color.white
	$ElementShield_2.modulate = Color.white
	$CollisionShape2D.disabled = false
	immunities = []

func _process(delta):
	if can_move:
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
	$AimReticle.position = get_local_mouse_position()

func _on_Player_body_entered(body):
	# something about damage here probably
#	print("Player body entered by " + body.name)
	if (body is Projectile or body is Mob) and body.element_type != Elements.type.NONE:
		var dealt_damage = false;
		match body.element_type:
			Elements.type.FIRE:
				if axis_fire_water != Elements.type.FIRE:
#					print("took fire damage")
					health -= body.damage
					dealt_damage = true
#				else:
#					print("ignored fire damage")
			Elements.type.WATER:
				if axis_fire_water != Elements.type.WATER:
#					print("took water damage")
					health -= body.damage
					dealt_damage = true
#				else:
#					print("ignored water damage")
			Elements.type.AIR:
				if axis_fire_water != Elements.type.AIR:
#					print("took air damage")
					health -= body.damage
					dealt_damage = true
#				else:
#					print("ignored air damage")
			Elements.type.EARTH:
				if axis_fire_water != Elements.type.EARTH:
#					print("took earth damage")
					health -= body.damage
					dealt_damage = true
#				else:
#					print("ignored earth damage")
		if body is Projectile: 
			body.destroy(dealt_damage)
		if dealt_damage:
			emit_signal("player_health", health)
			check_if_dead()
	pass # Replace with function body.

func set_axis(type):
	if type == Elements.type.FIRE or type == Elements.type.WATER:
		axis_fire_water = type
		$ElementShield_1.show()
		$ElementShield_1.modulate = Elements.color[type]
	elif type == Elements.type.AIR or type == Elements.type.EARTH:
		axis_air_earth = type
		$ElementShield_2.show()
		$ElementShield_2.modulate = Elements.color[type]
#	print("new axes are " + Elements.names[axis_fire_water] + " and " + Elements.names[axis_air_earth])

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
	$ElementShield_1.modulate = Elements.color[axis_fire_water]
	$ElementShield_2.modulate = Elements.color[axis_air_earth]
	print("new axes are " + Elements.names[axis_fire_water] + " and " + Elements.names[axis_air_earth])

func _input(event):
	if event is InputEventMouseButton and can_fire():
		$AimReticle.play("click")
		fire()
	if event.is_action_pressed("ui_interact"):
		var nearest_pickup = find_nearest_pickup()
		if nearest_pickup != null:
			set_axis(nearest_pickup.element_type)
			nearest_pickup.destroy()
	if event.is_action_pressed("ui_select"):
		flip_axes()

func can_fire():
	return can_move and OS.get_ticks_msec() > time_last_fired + fire_interval_ms

func fire():
	var projectile = player_projectile.instance()
	get_parent().get_node("Projectiles").add_child(projectile)
	var projectile_start_pos = position + get_local_mouse_position().normalized() *35
	projectile.start(projectile_start_pos, get_local_mouse_position(), 200, Elements.type.NONE, 1)
	can_fire = false
	time_last_fired = OS.get_ticks_msec()

func _on_AimReticle_animation_finished():
	if $AimReticle.animation == "click":
		$AimReticle.play("default")

func find_nearest_pickup():
	var all_pickups = get_parent().get_node("Pickups").get_children()
	var min_dist = 10000
	var closest = null
	for pickup in all_pickups:
		if pickup is Pickup:
			if pickup.can_be_picked_up:
				var dist = position.distance_to(pickup.position)
				if dist < min_dist:
					min_dist = dist
					closest = pickup
	return closest

func check_if_dead():
	if health <= 0:
		emit_signal("killed")
		can_move = false
		$AnimatedSprite.play("death")
		
