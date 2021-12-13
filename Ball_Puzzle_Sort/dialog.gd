extends Control

export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.2

onready var container = $Container
onready var tween = $Tween

var level = -1
var isEnd = false

func _ready():
	hide()
	
func open():
	modulate.a = 0
	get_node("Container/Label").text = "LEVEL " + str(level)
	get_node("Container/NextLevel").disabled = isEnd
	print(level)
	show()
	var position = container.rect_position
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0,
			fade_in_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(container, "rect_position",
			Vector2(position.x, position.y - 20), position, fade_in_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func close():
	
	var position = container.rect_position
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0,
			fade_out_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(container, "rect_position",
			position, Vector2(position.x, position.y - 20), fade_out_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func _on_Home_pressed():
	close()
	get_tree().change_scene("res://home.tscn")

func _on_NextLevel_pressed():
	close()
	get_tree().get_root().get_child(0).nextLevel()

func _on_tween_all_completed():
	if modulate.a < 0.5:
		hide()
