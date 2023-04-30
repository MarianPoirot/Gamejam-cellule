extends Node2D

class_name Cellule

signal getPoint
signal justDying(cell)

var life=100
var manager : Main
var currentUpgrade : int = -1

func TransformProd():
	$AnimatedSprite2D.play("Cellule_prod")
	$AnimatedSprite2D.scale *= 2
	$ProdTimer.start()
	
func TransformAttack():
	$AnimatedSprite2D.play("Cellule_attack")
	$AnimatedSprite2D.scale *= 2

func TransformDiv():
	$AnimatedSprite2D.play("Cellule_div")
	$AnimatedSprite2D.scale *= 2
	$DivTimer.start()
	
func Spawn(dest : Vector2):
	$AnimatedSprite2D.animation = "Cellule"
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ONE*0.1, 1).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "position", dest, 1)

func _hit(_viewport, event, _shape_idx):
	if(event is InputEventMouseButton and event.is_pressed()):
		if(event.button_index == MOUSE_BUTTON_LEFT):
			emit_signal("getPoint")
		if manager.SELECTED_UPGRADE !=-1 && currentUpgrade == -1 && manager.CanBuyCurrent():
			currentUpgrade = manager.SELECTED_UPGRADE
			match manager.SELECTED_UPGRADE:
				0:
					TransformProd()
				1:
					TransformAttack()
				2:
					TransformDiv()
			manager.applyUpgradeCost()

#Manage damage when enemy enter cell
func _on_area_2d_area_entered(area):
	var enemy=area.get_parent()
	life-=enemy.strength
	if life<=0:
		die()

func die():
	emit_signal("justDying",self)
	queue_free()

func _on_prod_timer_timeout():
	emit_signal("getPoint")
	$ProdTimer.start(1)


func _on_div_timer_timeout():
	manager.newCell(position,self)

func stopDivTimer():
	$DivTimer.stop()
