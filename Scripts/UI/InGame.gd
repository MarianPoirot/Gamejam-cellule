extends CanvasLayer

class_name InGameUI

signal selectUpdate(index : int)

@onready
var _timeLabel : Label = $Time
@onready
var _resourceLabel : Label = $ResourcesGrid/Resource

var _runStart : int = 0
var prodPrice : int = 100
var combatPrice : int = 100
var divisionPrice : int = 100

@onready
var prodButton : TextureButton = $Upgrade/ProdButton
@onready
var combatButton : TextureButton = $Upgrade/CombatButton
@onready
var divisionButton : TextureButton = $Upgrade/DivisionButton

func _startRun():
	_runStart = Time.get_ticks_msec()

func _process(_delta):
	updateTime()

func updateTime():
	var currentTime = Time.get_ticks_msec() - _runStart
	var inSecond : int = currentTime/1000
	var minute = "%02d" % (inSecond/60)
	var sec = "%02d" % (inSecond%60)
	var msec = "%03d" % (currentTime%1000)
	_timeLabel.text = minute + ":" + sec + ":" + msec

func updateResources(nb : int):
	_resourceLabel.text = " : " + str(nb)
	prodButton.disabled = nb<prodPrice
	combatButton.disabled = nb<combatPrice
	divisionButton.disabled = nb<divisionPrice



func _on_prod_button_toggled(button_pressed):
	if(button_pressed):
		combatButton.button_pressed = false
		divisionButton.button_pressed = false
		emit_signal("selectUpdate",0)
	if(!button_pressed && prodButton.pressed):
		emit_signal("selectUpdate",-1)


func _on_division_button_toggled(button_pressed):
	if(button_pressed):
		prodButton.button_pressed = false
		combatButton.button_pressed = false
		emit_signal("selectUpdate",2)
	if(!button_pressed && divisionButton.pressed):
		emit_signal("selectUpdate",-1)

