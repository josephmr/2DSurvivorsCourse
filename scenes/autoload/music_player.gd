extends AudioStreamPlayer

@onready var timer: Timer = $Timer

func _ready():
	finished.connect(on_finished)
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	play()


func on_finished():
	timer.start()
