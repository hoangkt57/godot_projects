extends Area2D


const PIPE_BOTTOM = 148.0
const PIPE_TOP = 18.0
const PIPE_SIZE = 50.0

var isTop = false

func changeSize(height: int):
	var direction = -1
	if(isTop):
		direction = 1
	var top = get_node("Sprite2")
	var bottom = get_node("Sprite")
	var shape = get_node("CollisionShape2D")
	
	top.rotation_degrees = 180
	bottom.rotation_degrees = 180
	top.position = Vector2(0, direction * (height-PIPE_TOP)/2)
	bottom.position = Vector2(0, direction * (0-PIPE_TOP)/2)
	bottom.scale.y = (height-PIPE_TOP) / PIPE_BOTTOM
	shape.scale.y = height / (PIPE_BOTTOM + PIPE_TOP)
