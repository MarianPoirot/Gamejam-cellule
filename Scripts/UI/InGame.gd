extends CanvasLayer

@onready
var _timeLabel : Label = $Time

var _runStart : int = 0

func startGame():
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
