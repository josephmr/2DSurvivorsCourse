extends CanvasLayer

@export var experience_manager: ExperienceManager

@onready var progress_bar: ProgressBar = %ProgressBar

func _ready():
	progress_bar.value = 0
	if experience_manager:
		experience_manager.experience_updated.connect(on_experience_updated)


func on_experience_updated(current_experience: float, target_experience: float):
	progress_bar.value = current_experience / target_experience
