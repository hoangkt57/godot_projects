extends Node2D

class Tube:
	var id = -1
	var position = Vector2()
	var balls = []
	var ballNodes = []
	
const CONTAINS = preload("res://contains.gd")
const LEVEL = preload("res://data.gd")

onready var tween = $Tween
onready var dialog = $InterfaceLayer/Dialog

var tubes = []
var tubeNodes = []

var data = []
var animateBall = []
var idSelected = -1
var currentLevel = 0

func _ready():
	print("_ready" + str(self))
	
	for level in LEVEL.getData():
		data.append(parse_json(level))
	createLevel(currentLevel)

func _draw():
	print("_draw")
	for tube in tubes:
		var node = drawTube(tube.id, tube.position)
		tubeNodes.append(node)
	for tube in tubes:
		var count = 1
		for id in tube.balls:
			var ball = createBall(id,count,tube.position)
			add_child(ball)
			tube.ballNodes.append(ball)
			count = count +1
			
func reset():
	if(tubeNodes.size() != 0):
		for tube in tubeNodes:
			remove_child(tube)
	for tube in tubes:
		for node in tube.ballNodes:
			remove_child(node)
		tube.ballNodes.clear()
	tubeNodes.clear()
	idSelected = -1
	animateBall.clear()
	tubes.clear()
			
func createLevel(level: int) -> bool:
	if(level >= data.size()):
		return false
	var level1 = data[level]
	var bgPosition = get_node("TubeRect").rect_position
	var bgSize = get_node("TubeRect").rect_size
	var tubePosition = getPositionTube(level1.size(),bgPosition,bgSize)
	reset()
	for i in level1:
		var position = tubePosition.get(i)
		var tube = Tube.new()
		tube.position = position
		tube.id = int(i)
		tube.balls = level1[i]
		tubes.append(tube)
	return true

func handleClick(id):
	print("handleClick " + str(id))
	var tube = tubes[id-1]
	var ballSize = tube.ballNodes.size()
	if(idSelected == -1 && ballSize == 0):
		return
	
	if(idSelected == -1 && ballSize > 0):
		var ball = tube.ballNodes[ballSize-1]
		idSelected = id
		tween.interpolate_method(ball,"set_position", ball.position,tube.position,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
	else:
		var tube1 = tubes[idSelected-1]
		var ballSize1 = tube1.ballNodes.size()
		var ball1 = tube1.ballNodes[ballSize1-1]
		if(ballSize==0):
			animateBall.push_back(tube.position)
			animateBall.push_back(getBallPosition(1, tube.position))
			moveBall(ball1)
			swapBall(tube1, ball1, tube)
			idSelected = -1
			return
			
		var ball = tube.ballNodes[ballSize-1]
		if(idSelected == id):
			var newPosition = getBallPosition(ballSize, tube.position)
			idSelected = -1
			tween.interpolate_method(ball,"set_position", ball.position,newPosition,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.start()
		elif(ball1.id != ball.id || ballSize == CONTAINS.MAX_BALL):
			var pos1 = getBallPosition(ballSize1, tube1.position)
			var pos = tube.position
			idSelected = id
			tween.interpolate_method(ball1,"set_position", ball1.position,pos1,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.interpolate_method(ball,"set_position", ball.position,pos,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.start()
		else:
			animateBall.push_back(tube.position)
			animateBall.push_back(getBallPosition(ballSize +1, tube.position))
			moveBall(ball1)
			swapBall(tube1, ball1, tube)
			idSelected = -1
			 
	
func moveBall(ball: Node2D):
	if(animateBall.size() == 0):
		return
	var newPosition = animateBall.pop_front()
	tween.interpolate_method(ball,"set_position", ball.position,newPosition,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()

func swapBall(tube1: Tube, ball1: Node2D, tube2: Tube):
	var index = 0
	for ball in tube1.ballNodes:
		if(ball == ball1):
			tube1.ballNodes.remove(index)
			break
		index = index+1
	tube2.ballNodes.append(ball1)
	
func checkBall() -> bool:
	for tube in tubes:
		var oldId = -1
		if(tube.ballNodes.size()!=0 && tube.ballNodes.size() != CONTAINS.MAX_BALL):
			return false
		for ball in tube.ballNodes:
			if(oldId == -1):
				oldId = ball.id
			if(oldId != ball.id):
				return false
	return true
	
func drawTube(id: int, position: Vector2) -> Node2D:
	var node = preload("res://Tube.scn").instance()
	node.move_local_x(position.x, false)
	node.move_local_y(position.y, false)
	node.id = id
	add_child(node)
	return node
	
func createBall(id: int, index: int, tubePosition: Vector2) -> Node2D:
	var position = getBallPosition(index, tubePosition)
	var node = preload("res://Ball.scn").instance()
	node.id = id
	node.get_node("Sprite").frame = id
	node.move_local_x(position.x, false)
	node.move_local_y(position.y, false)
	return node
	
func getBallPosition(index: int, position: Vector2) -> Vector2:
	assert(index > 0 and index < 5)
	var x = position.x
	var y = position.y + CONTAINS.TUBE_HEIGHT - index * CONTAINS.BALL_SIZE - (index -1) * CONTAINS.PADDING
	return Vector2(x,y)
	
func getPositionTube(count: int, parentPosition: Vector2, parentSize: Vector2) -> Dictionary:
	assert(count>0 and count <=6)
	var data = {}
	var maxCount = 3
	if(count <= maxCount):
		var marginHorizontal = (parentSize.x - CONTAINS.TUBE_WITH * count) / (count + 1)
		var marginVertical = (parentSize.y - CONTAINS.TUBE_HEIGHT) / 2
		for i in count: 
			var position = Vector2(parentPosition.x + CONTAINS.TUBE_WITH/2 + marginHorizontal*(i+1) + CONTAINS.TUBE_WITH*i,parentPosition.y + marginVertical)
			data[str(i+1)] = position
	else:
		var marginHorizontal1 = (parentSize.x - CONTAINS.TUBE_WITH * maxCount) / (maxCount + 1)
		var marginHorizontal2 = (parentSize.x - CONTAINS.TUBE_WITH * (count - maxCount)) / (count - maxCount + 1)
		var marginVertical = (parentSize.y - CONTAINS.TUBE_HEIGHT * 2) / 3
		for i in maxCount: 
			var position = Vector2(parentPosition.x + CONTAINS.TUBE_WITH/2 + marginHorizontal1*(i+1) + CONTAINS.TUBE_WITH*i,parentPosition.y + marginVertical)
			data[str(i+1)] = position
		for i in range(maxCount, count):
			var position = Vector2(parentPosition.x + CONTAINS.TUBE_WITH/2 + marginHorizontal2*(i-maxCount+1) + CONTAINS.TUBE_WITH*(i-maxCount),parentPosition.y + marginVertical*2 + CONTAINS.TUBE_HEIGHT)
			data[str(i+1)] = position
	return data

func _on_Ball_tween_completed(object, key):
	if(animateBall.size() == 0):
		var result = checkBall()
		if(result):
			dialog.level = currentLevel + 1
			if(dialog.level == data.size()):
				dialog.isEnd = true
			dialog.open()
		print(result)
	if(object is Node2D):
		moveBall(object)
	
func _on_Home_pressed():
	print("_on_Home_pressed")
	get_tree().change_scene("res://home.tscn")

func _on_Reset_pressed():
	reset()
	update()
	
func nextLevel():
	currentLevel = currentLevel + 1
	if(createLevel(currentLevel)):
		update()
	else:
		print("END..............")


func _on_TubePlus_pressed():
	if(currentLevel >= data.size()):
		return
	var level = data[currentLevel]
	var size = level.size()
	if(size >= CONTAINS.MAX_TUBE):
		return
	level[str(size+1)] = []
	createLevel(currentLevel)
	update()
	
