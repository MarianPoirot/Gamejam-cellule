extends Sprite2D

var dir = Vector2.ZERO
const SPEED = 500

var damage : float = 0.5

func _process(delta):
	position += (delta * dir * SPEED)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	area.get_parent().takeDamage(damage)
	queue_free()
