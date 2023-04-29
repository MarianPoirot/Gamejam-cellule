extends CanvasLayer

class_name InGameUI

@onready
var _timeLabel : Label = $Time
@onready
var _resourceLabel : Label = $ResourcesGrid/Resource

var _runStart : int = 0

func _startRun():
	_runStart = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateTime()

func updateTime():
	var currentTime = Time.get_ticks_msec() - _runStart
	var inSecond : int = currentTime/1000
	var min = "%02d" % (inSecond/60)
	var sec = "%02d" % (inSecond%60)
	var msec = "%03d" % (currentTime%1000)
	_timeLabel.text = min + ":" + sec + ":" + msec

func updateResources(nb : int):
	_resourceLabel.text = " : " + str(nb)
 
