extends Node2D

signal getHit(pin)
var _hover : bool = false

func Spawn():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "scale", Vector2.ONE*0.1, 1).set_trans(Tween.TRANS_QUAD)


func _on_static_body_2d_input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		emit_signal("getHit", self)
