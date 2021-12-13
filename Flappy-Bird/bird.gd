extends RigidBody2D


var isMoveUp = false
var isFalling = false
var isIdle = true
const ROTATION = 20
onready var bird = get_node("AnimatedSprite")

func _ready():
	play()

func play():
	isMoveUp = false
	isIdle = true
	isFalling = false
	bird.rotation_degrees = 0
	bird.play("BIRD", false)

func _physics_process(delta):
	if(isFalling || isIdle):
		return
	if(!isMoveUp && Input.is_action_pressed("ui_accept")):
		set_axis_velocity(Vector2(0,-200))
		isMoveUp = true
		bird.rotate(-ROTATION)
	
	if(Input.is_action_just_released("ui_accept")):
		if(bird.rotation_degrees != 0):
			bird.rotate(ROTATION)
		isMoveUp = false

func _on_Floor_body_entered(body):
	if(body == self):
		bird.stop()

func _on_Area2D_area_entered(area):
	isFalling = true
