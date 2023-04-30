extends CanvasLayer

var main = preload("res://Scenes/main.tscn").instantiate()

func _physics_process(_delta):
	if Input.is_action_pressed("start"):
		_on_start_button_button_down()

func _on_start_button_button_down():
	if get_tree().change_scene_to_file("res://Scenes/main.tscn") != OK:
		print ("Error passing from Opening scene to main scene")
