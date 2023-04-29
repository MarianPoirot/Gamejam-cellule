extends CharacterBody2D

@export var min_speed = 50  # Minimum speed range.
@export var max_speed = 150  # Maximum speed range.
var speed = 0
var target_position= Vector2(800,450)
var attack = false
var move = true
var closestCell

# Called when the node enters the scene tree for the first time.
func _ready():
	closestCell = get_closest_cell()
	target_position= closestCell.position
	
	var roll = randi()%100
	if (roll < 99):
		$AnimatedSprite2D.animation = "virus_move"
		$AnimatedSprite2D.scale.x=0.125
		$AnimatedSprite2D.scale.y=0.125
	else:
		$AnimatedSprite2D.animation = "kirbo_move"
		$AnimatedSprite2D.scale.x=0.25
		$AnimatedSprite2D.scale.y=0.25

func get_closest_cell():
	var min_dist = 9999
	var min_cell
	var cells = get_tree().get_nodes_in_group("cells")
	for cell in cells:
		var dist = self.position.distance_to(cell.position)
		if (dist < min_dist):
			min_dist = dist
			min_cell = cell
	return min_cell
	
func _physics_process(_delta: float) -> void:
	if move:
		var direction = global_position.direction_to(target_position)
		velocity = direction*speed
		self.move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		queue_free()

func _on_cooldown_attack_timeout():
	target_position= closestCell.position
	move = true

func _on_click_area_area_entered(area):
	emit_signal("hit")
	
