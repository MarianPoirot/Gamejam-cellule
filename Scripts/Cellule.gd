extends Node2D

class_name Cellule

signal getPoint
signal justDying(cell)

var life=100
var manager : Main
var currentUpgrade : int = -1

var target : Array
var carreauScene = preload("res://Scenes/Carreau.tscn")

func _process(_delta):
	while target.size() > 0 && target[0] == null:
		target.remove_at(0)
	if currentUpgrade == 1:
		if target.size() == 0:
			$ShootTimer.stop()
		else:
			look_at(target[0].position)

func TransformProd():
	$AnimatedSprite2D.play("Cellule_prod")
	$AnimatedSprite2D.scale *= 2
	$ProdTimer.start()
	
func TransformAttack():
	$AnimatedSprite2D.play("Cellule_attack")
	$AnimatedSprite2D.scale *= 2
	$ShootTimer.start()

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
			$CPUParticles2D.modulate=Color(1,1,0,1)
			$CPUParticles2D.emitting = true
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
	$CPUParticles2D.modulate=Color(1,0.5,0,1)
	$CPUParticles2D.emitting = true
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

func get_closest_enemy():
	var dist
	var mobs = get_tree().get_nodes_in_group("mobs")
	if(mobs.size() == 0):
		return null
	var min_mob = mobs[0]
	var min_dist = self.global_position.distance_to(mobs[0].position)
	for mob in mobs:
		dist = self.global_position.distance_to(mob.position)
		if (dist < min_dist):
			min_dist = dist
			min_mob = mob
	return min_mob


func _on_shoot_timer_timeout():
	if target.size() > 0:
		var pos = target[0].position
		var spear = carreauScene.instantiate()
		spear.position = position
		spear.dir = (pos - position).normalized()
		spear.look_at(pos)
		get_parent().add_child(spear)


func _on_detection_zone_area_entered(area):
	target.append(area.get_parent())
	if($ShootTimer.is_stopped() && currentUpgrade == 1):
		$ShootTimer.start()
