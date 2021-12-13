extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	OS.window_size = Vector2(360,740)



func _on_Area2D_input_event(viewport, event, shape_idx):
	print(event)


func _on_Play_pressed():
	pass # Replace with function body.
