extends CanvasLayer

var main = preload("res://Scenes/main.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Time.text = Global.time
	$ResourcesGrid/Resource.text = Global.score

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_button_down():
	if get_tree().change_scene_to_file("res://Scenes/main.tscn") != OK:
		print ("Error passing from Opening scene to main scene")
