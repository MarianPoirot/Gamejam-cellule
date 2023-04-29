extends CanvasLayer

class_name Main

var nbResource : int = 0

@onready
var UI : InGameUI = $InGame
@onready
var _map : Map = $Map

func _ready():
	UI._startRun()
	UI.updateResources(nbResource)

func _unhandled_input(event):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		if(_map.isProductiveCell()):
			nbResource+=1
			UI.updateResources(nbResource)
