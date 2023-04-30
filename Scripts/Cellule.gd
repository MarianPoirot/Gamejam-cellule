extends Node2D

class_name Cellule

signal getHit

var life=100

func TransformProd():
	$AnimatedSprite2D.animation = "Cellule_prod"
	$ProdTimer.start()
	
func TransformAttack():
	$AnimatedSprite2D.animation = "Cellule_attack"
	
func Spawn(dest : Vector2):
	$AnimatedSprite2D.animation = "Cellule"
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ONE*0.1, 1).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "position", dest, 1)

func _hit(viewport, event, shape_idx):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		emit_signal("getHit")

#Manage damage when enemy enter cell
func _on_area_2d_area_entered(area):
	var enemy=area.get_parent()
	life-=enemy.strength
	if life<=0:
		die()

func die():
	queue_free()

func _on_prod_timer_timeout():
	emit_signal("getHit")
