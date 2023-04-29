extends Area2D

@export var min_speed = 150  # Minimum speed range.
@export var max_speed = 250  # Maximum speed range.

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = "move"
