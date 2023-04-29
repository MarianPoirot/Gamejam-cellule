extends CharacterBody2D

@export var min_speed = 500  # Minimum speed range.
@export var max_speed = 500  # Maximum speed range.
var speed = 50
var target_position= Vector2(800,450)

# Called when the node enters the scene tree for the first time.
func _ready():
	var roll = randi()%100
	if (roll < 70):
		$AnimatedSprite2D.animation = "virus_move"
		$AnimatedSprite2D.scale.x=0.125
		$AnimatedSprite2D.scale.y=0.125
	else:
		$AnimatedSprite2D.animation = "kirbo_move"
		$AnimatedSprite2D.scale.x=0.25
		$AnimatedSprite2D.scale.y=0.25
		
	
	

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(target_position)
	velocity = direction*speed
	self.move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
