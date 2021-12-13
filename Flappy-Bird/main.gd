extends Node2D

onready var tween = $Tween

const TIME = 0.8
const START_POS = Vector2(88,250)
const END_POS = Vector2(88,300)

var isIdle = true

func _ready():
	prepare()
	
func _physics_process(delta):
	if(isIdle && Input.is_action_pressed("ui_accept")):
		isIdle = false
		get_node("Instructions").visible = false
		get_node("PipeContainer").createPipe()
		var bird = get_node("RigidBody2D")
		tween.stop(bird)
		tween.remove_all()
		bird.isIdle = false
		bird.gravity_scale = 6
	
func prepare():
	get_node("Instructions").visible = true
	get_node("PipeContainer").clear()
	isIdle = true
	var bird = get_node("RigidBody2D")
	bird.gravity_scale = 0
	bird.play()
	tween.remove_all()
	tween.interpolate_method(bird, "set_position", START_POS, END_POS, TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(bird, "position", END_POS, START_POS, TIME, Tween.TRANS_LINEAR, Tween.EASE_IN, TIME)
	tween.repeat = true
	tween.start()


func _on_Floor_body_entered(body):
	print(body)
	if(body is RigidBody2D):
		print(body.isFalling)
		get_node("CanvasLayer/Dialog").open()

func _on_Dialog_Start_pressed():
	print("_on_Dialog_Start_pressed")
	get_node("CanvasLayer/Dialog").close()
	prepare()
