extends CanvasLayer

class_name Main

var nbResource : int = 0

var _pinScene : PackedScene = preload("res://Scenes/Pin.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@onready
var UI : InGameUI = $InGame
@onready
var _map = $Map
@onready
var _pinTimer : Timer = $PinSpawn

func _ready():
	UI._startRun()
	UI.updateResources(nbResource)
	_pinTimer.start(rng.randi_range(1,5))

func _unhandled_input(event):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		if(_map.isProductiveCell()):
			IncreaseResource(1)


func _spawnPin():
	var entity : Node2D = _pinScene.instantiate()
	entity.position = Vector2(rng.randf()*get_viewport().size.x, rng.randf()*get_viewport().size.y)
	add_child(entity)
	_pinTimer.start(rng.randi_range(1,5))
	entity.Spawn()
	entity.getHit.connect(HitBonus)

func HitBonus(pin : Node2D):
	pin.queue_free()
	IncreaseResource(100)

func IncreaseResource(nb : int):
	nbResource+=nb
	UI.updateResources(nbResource)
