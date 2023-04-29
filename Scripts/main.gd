extends CanvasLayer

class_name Main

var nbResource : int = 0

var _pinScene : PackedScene = preload("res://Scenes/Pin.tscn")
var _cellScene : PackedScene = preload("res://Scenes/Cellule.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@onready
var UI : InGameUI = $InGame
@onready
var _map = $Map
@onready
var _pinTimer : Timer = $PinTimer
@onready
var _cellulesPool = $Cellules
@export var Enemy: PackedScene

func _ready():
	UI._startRun()
	UI.updateResources(nbResource)
	_pinTimer.start(rng.randi_range(1,5))

	#Cellule originelle
	var gridCoord = _map.alignCoord(_map.center())
	var cell = _cellScene.instantiate()
	cell.position = gridCoord
	cell.getHit.connect(HitBase)
	_cellulesPool.add_child(cell)
	cell.Spawn(gridCoord)

func new_game():
	$MobTimer.start()

func _unhandled_input(event):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed()):
		newCell(_map.center())

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

func HitBase():
	IncreaseResource(1)

func IncreaseResource(nb : int):
	nbResource+=nb
	UI.updateResources(nbResource)


func _on_mob_timer_timeout():
	var mob = Enemy.instantiate()
	# Choose a random location on Path2D.
	$EnemyPath/EnemyPathFollow.progress_ratio = randi()
	# Create a Mob instance and add it to the scene.
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $EnemyPath/EnemyPathFollow.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $EnemyPath/EnemyPathFollow.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Set the velocity (speed).
	mob.speed = randf_range(mob.min_speed, mob.max_speed)

func _on_start_button_button_down():
	$MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	new_game()

func newCell(origine : Vector2):
	var dest = _map.findNeighbor(origine)
	if dest != origine:
		var cell = _cellScene.instantiate()
		cell.position = origine
		cell.getHit.connect(HitBase)
		_cellulesPool.add_child(cell)
		cell.Spawn(dest)
