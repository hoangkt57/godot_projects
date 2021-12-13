extends Node2D

const EMPTY_CHAR = "."
const BRICK_CHAR = "#"
const STONE_CHAR = "@"

const BRICK_FRAME = 0
const STONE_FRAME = 1

const TILE_SIZE = 16

var map = []
var boardPosition = Vector2.ZERO

class Tile:
	var type = -1
	var position = Vector2.ZERO
	
	func _init(param1, param2):
		type = param1
		position = param2


func _ready():
	print(self)
	var board = get_node("Board")
	boardPosition = get_node("Board/BoardColor").rect_position
	print(boardPosition)
	
	var tank = preload("res://player.tscn").instance()
	tank.position = Vector2(100,100)
	board.add_child(tank)
	getLevel()
	
	for tile in map:
		var node = preload("res://tile.tscn").instance()
		node.get_node("Sprite").frame = tile.type
		node.position = boardPosition + tile.position * TILE_SIZE + Vector2(8,8)
		board.add_child(node)


func getLevel():
	var file = File.new()
	file.open("user://levels/1",File.READ)
	var x = 0
	var y = 0
	while not file.eof_reached():
		var line = file.get_line()
		x = 0
		for i in line:
			if(i != EMPTY_CHAR):
				if(i == BRICK_CHAR):
					map.append(Tile.new(BRICK_FRAME,Vector2(x,y)))
				elif(i == STONE_CHAR):
					map.append(Tile.new(STONE_FRAME,Vector2(x,y)))
			x+=1
		y+=1
	file.close()


