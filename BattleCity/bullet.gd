extends KinematicBody2D


const SPEED  = 150
var direction = Vector2()
var velocity = Vector2()
var isRunning= false

func _ready():
	pass


func _process(delta):
	if(isRunning):
		velocity = direction
		velocity = velocity.normalized() * SPEED
		velocity = move_and_slide(velocity)
	

func start(dir : Vector2):
	direction = dir
	isRunning = true
	isRunning = true
