extends Node2D

var id

func _ready():
	print("ready tube - " + str(id))

func _on_Tube_input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
		get_parent().call("handleClick",id)
		
