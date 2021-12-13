extends KinematicBody2D


const SIZE = Vector2(26,160)

func changeSize(height: int):
	get_node("Sprite").scale.y = height / SIZE.y
	get_node("CollisionShape2D").scale.y = height / SIZE.y
