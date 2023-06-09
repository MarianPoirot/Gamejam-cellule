extends Node2D

signal getHit(pin)

func Spawn():
	var tween = get_tree().create_tween()
	tween.parallel().tween_property($Sprite, "scale", Vector2.ONE*0.1, 1).set_trans(Tween.TRANS_QUAD)

func _on_static_body_2d_input_event(_viewport, event, _shape_idx):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		emit_signal("getHit", self)

func _on_static_body_2d_area_entered(area):
	queue_free()
