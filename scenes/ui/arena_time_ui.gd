extends CanvasLayer

@export var arena_time_manager: ArenaTimeManager

@onready var label: Label = %Label

func _process(delta: float) -> void:
	label.text = format_seconds(arena_time_manager.get_time_elapsed())


func format_seconds(seconds: float) -> String:
	var minutes = floor(seconds / 60)
	var remaining_seconds = floor(int(seconds) % 60)
	return "%d:%02d" % [minutes, remaining_seconds]
