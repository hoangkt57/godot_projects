extends KinematicBody2D


const SPEED  = 80
const WAIT_TIME = 0.8
var timer = 0
var velocity = Vector2()
var isReload = false

func _process(delta):
	timer += delta
	if timer > WAIT_TIME:
		timer = 0
		isReload = false

func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		rotation_degrees = 90
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		rotation_degrees = -90
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		rotation_degrees = 180
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		rotation_degrees = 0
	
	if Input.is_action_pressed("ui_accept"):
		fire()
		
	velocity = velocity.normalized() * SPEED
	velocity = move_and_slide(velocity)


func explode():
	get_node("Tank").visible = false
	get_node("Explode").visible = true
	get_node("Explode/AnimationPlayer").play("explode")
	
func fire():
	if(isReload):
		return
	isReload = true
	var board = get_parent()
	print(board)
	var bullet = preload("res://bullet.tscn").instance()
	var direction = bulletDirection()
	bullet.rotation_degrees = rotation_degrees
	bullet.position = position + direction * 18
	board.add_child(bullet)
	bullet.start(direction)
	
func bulletDirection() -> Vector2:
	var degress = round(rotation_degrees)
	print(degress)
	if(degress == 0):
		return Vector2(0, -1)
	if(degress == 90):
		return Vector2(1, 0)
	if(degress == -90):
		return Vector2(-1, 0)
	if(degress == 180 || degress == -180):
		return Vector2(0, 1)
	return Vector2.ZERO

	
