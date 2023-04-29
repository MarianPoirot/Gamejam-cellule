extends CharacterBody2D

@export var min_speed = 50  # Minimum speed range.
@export var max_speed = 50  # Maximum speed range.

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
	self.move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
