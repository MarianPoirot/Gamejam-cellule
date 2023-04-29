extends Node2D

class_name Cellule

signal getHit

func Spawn(dest : Vector2):
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ONE*0.1, 1).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "position", dest, 1)


func _hit(viewport, event, shape_idx):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		emit_signal("getHit")
