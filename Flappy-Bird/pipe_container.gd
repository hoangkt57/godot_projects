extends Control

const PIPE_COUNT = 5
const PIPE_WIDTH = 50
const PIPE_SPACE_HORIZONTAL = 150
const PIPE_SPACE_VERTICAl = 95
const SPEED = Vector2(-140, 0)

var pipes = []
var size = Vector2()
var status= -1

class Pipe:
	var topNode = Node2D.new()
	var bottomNode = Node2D.new()
	var topHeight

func _ready():
	size = get_rect().size
	
func createPipe():
	var startX = get_viewport_rect().size.x  + PIPE_WIDTH
	for i in PIPE_COUNT:
		if(pipes.size() != 0):
			startX = startX + PIPE_SPACE_HORIZONTAL + PIPE_WIDTH
		var pipe = Pipe.new()
		pipe.topHeight = rand_range(0.2*size.y,0.8*size.y)
		pipe.topNode = preload("res://Pipe.tscn").instance()
		pipe.topNode.isTop = true
		pipe.topNode.changeSize(pipe.topHeight)
		pipe.topNode.position = Vector2(startX,  pipe.topHeight/2)
		
		var bottomHeight = size.y - PIPE_SPACE_VERTICAl - pipe.topHeight
		pipe.bottomNode = preload("res://Pipe.tscn").instance()
		pipe.bottomNode.changeSize(bottomHeight)
		pipe.bottomNode.position = Vector2(startX,  size.y - bottomHeight/2)
		
#		print(str(pipe.topNode.position) + " - " + str(pipe.bottomNode.position))
#		print(str(pipe.topHeight) + " - " + str(bottomHeight))
		
		pipes.push_back(pipe)
		add_child(pipe.topNode)
		add_child(pipe.bottomNode)
	status = 1
	
func _process(delta):
	if(status == -1):
		return
	for pipe in pipes:
		if(pipe.topNode.position.x < -PIPE_WIDTH):
			changePipePosition(pipe)
		pipe.topNode.position += SPEED * delta
		pipe.bottomNode.position += SPEED * delta

func _on_Area2D_area_entered(area):
	status = -1
	
func changePipePosition(pipe: Pipe):
	var lastPipe
	var x = -1
	for p in pipes:
		if(p.topNode.position.x >= x):
			x = p.topNode.position.x
			lastPipe = p
	print("changePipePosition - " + str(pipe) + " - " + str(lastPipe))
	if(lastPipe == null):
		return
	
	var startX = lastPipe.topNode.position.x + PIPE_SPACE_HORIZONTAL + PIPE_WIDTH
	pipe.topHeight = rand_range(0.2*size.y,0.8*size.y)
	pipe.topNode.changeSize(pipe.topHeight)
	pipe.topNode.position = Vector2(startX,  pipe.topHeight/2)
	
	var bottomHeight = size.y - PIPE_SPACE_VERTICAl - pipe.topHeight
	pipe.bottomNode.changeSize(bottomHeight)
	pipe.bottomNode.position = Vector2(startX,  size.y - bottomHeight/2)
	
func clear():
	for pipe in pipes:
		remove_child(pipe.topNode)
		remove_child(pipe.bottomNode)
	pipes.clear()
	status = -1
