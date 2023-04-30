extends CanvasLayer

class_name Main

var SELECTED_UPGRADE : int = -1

var nbResource : int = 0

var _pinScene : PackedScene = preload("res://Scenes/Pin.tscn")
var _cellScene : PackedScene = preload("res://Scenes/Cellule.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@export
var upgradesCost : Array

@onready
var UI : InGameUI = $InGame
@onready
var _map = $Map
@onready
var _pinTimer : Timer = $PinTimer
@onready
var _cellulesPool = $Cellules
@export var Enemy: PackedScene

@export var clicDamage = 1

func _ready():
	new_game()
	UI.generalUpgrade.connect(generalUpgrade)

func new_game():
	$MobTimer.start()
	_pinTimer.start(rng.randi_range(1,5))
	
	upgradesCost = [100,100,10, 50]
	UI._startRun()
	UI.UpdateCost(upgradesCost)
	UI.updateResources(nbResource)
	_map.Init()
	SELECTED_UPGRADE = -1
	#Cellule originelle
	var gridCoord = _map.alignCoord(_map.center())
	var cell = _cellScene.instantiate()
	cell.manager = self
	cell.position = gridCoord
	cell.getPoint.connect(HitBase)
	_cellulesPool.add_child(cell)
	cell.Spawn(gridCoord)
	cell.justDying.connect(removeCellFromMap)

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
	# Choose a random location on Path2D.
	$EnemyPath/EnemyPathFollow.progress_ratio = randi()
	# Set the mob's direction perpendicular to the path direction.
	var direction = $EnemyPath/EnemyPathFollow.rotation + PI / 2
	# Create a Mob instance and add it to the scene.
	var mob = Enemy.instantiate()
	add_child(mob)
	# Set the mob's position to a random location.
	mob.position = $EnemyPath/EnemyPathFollow.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed).
	mob.speed = randf_range(mob.min_speed, mob.max_speed)
	mob.start()

func _on_start_button_button_down():
	$MobTimer.stop()
	_pinTimer.stop()
	get_tree().call_group("pin", "queue_free")
	get_tree().call_group("mobs", "queue_free")
	_map.clear()
	get_tree().call_group("cells", "queue_free")
	nbResource = 0
	new_game()

func newCell(origine : Vector2, cellule : Cellule):
	origine = _map.alignCoord(origine)
	var dest = _map.findNeighbor(origine)
	if dest != origine:
		var cell = _cellScene.instantiate()
		cell.manager = self
		cell.position = origine
		cell.getPoint.connect(HitBase)
		_cellulesPool.add_child(cell)
		cell.Spawn(dest)
		cell.justDying.connect(removeCellFromMap)
	else:
		cellule.stopDivTimer()

func updateUpgrade(index : int):
	SELECTED_UPGRADE = index

func applyUpgradeCost():
	IncreaseResource(-1* upgradesCost[SELECTED_UPGRADE])
	UI.UpdateCost(upgradesCost)

func CanBuyCurrent() -> bool:
	return nbResource >= upgradesCost[SELECTED_UPGRADE]
	
func removeCellFromMap(cell : Node2D):
	var mapCoord = _map.local_to_map(cell.position)
	_map.set_cell(0, mapCoord, -1)
	if get_tree().get_nodes_in_group("cells").size()==1:
		game_over()
		
func game_over():
	if get_tree().change_scene_to_file("res://Scenes/UI/Ending.tscn") != OK:
		print ("Error passing from Opening scene to main scene")

func generalUpgrade(index : int):
	if index == 1:
		clicDamage += 0.2
		#UI.UpdateCost(upgradesCost)
