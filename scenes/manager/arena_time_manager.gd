extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)

@export var end_screen_scene: PackedScene

@onready var timer: Timer = $Timer
@onready var difficulty_timer: Timer = $DifficultyTimer

var arena_difficulty = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)
	difficulty_timer.timeout.connect(on_difficulty_timer_timeout)


func on_difficulty_timer_timeout():
	arena_difficulty += 1
	arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	owner.add_child(end_screen_instance)
	MetaProgression.save()
