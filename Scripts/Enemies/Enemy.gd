extends CharacterBody2D

@export var min_speed = 50  # Minimum speed range.
@export var max_speed = 150  # Maximum speed range.
var speed = 0
var target_position= Vector2(800,450)
var attack = false
var move = true
var closestCell
var strength
var direction
var dist
var life

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Send a random type of enemy
	var roll = randi()%100
	if (roll < 99):
		$AnimatedSprite2D.animation = "virus_move"
		var roll2 = randi()%100
		if (roll < 80):
			$AnimatedSprite2D.scale.x=0.125
			$AnimatedSprite2D.scale.y=0.125
			strength = 10
			life = 1
		elif (roll<95):
			$AnimatedSprite2D.scale.x=0.175
			$AnimatedSprite2D.scale.y=0.175
			$ClickArea.scale.x=1.5
			$ClickArea.scale.y=1.5
			$Hurtbox.scale.x=1.5
			$Hurtbox.scale.y=1.5
			strength = 20
			life = 2
			speed -= 15
		else:
			$AnimatedSprite2D.scale.x=0.25
			$AnimatedSprite2D.scale.y=0.25
			$ClickArea.scale.x=2
			$ClickArea.scale.y=2
			$Hurtbox.scale.x=2
			$Hurtbox.scale.y=2
			strength = 40
			life = 3
			speed -= 30
	else:
		$AnimatedSprite2D.animation = "kirbo_move"
		$AnimatedSprite2D.scale.x=0.25
		$AnimatedSprite2D.scale.y=0.25
		strength = 1000
		life = 2

func start():
	#Get closest cell to focus and target it
	closestCell = get_closest_cell()
	if closestCell:
		target_position= closestCell.position

func get_closest_cell():
	var min_dist = 9999
	var min_cell
	var cells = get_tree().get_nodes_in_group("cells")
	for cell in cells:
		dist = self.global_position.distance_to(cell.position)

		if (dist < min_dist):
			min_dist = dist
			min_cell = cell
	return min_cell
	
func _physics_process(_delta: float) -> void:
	if move:
		direction = global_position.direction_to(target_position)
		velocity = direction*speed
		self.move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		takeDamage(1)

func _on_cooldown_attack_timeout():
	$CooldownAttack.stop()
	#Get closest cell to focus and target it
	closestCell = get_closest_cell()
	if closestCell:
		target_position= closestCell.position
	move = true
	attack=false
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)

func _on_hurtbox_area_entered(_area):
	move=false
	attack=true
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$CooldownAttack.start()

func takeDamage(damage):
	life-=damage
	if life<=0:
		queue_free()
