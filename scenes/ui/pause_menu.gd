extends CanvasLayer

signal resume_pressed

@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer

var options_scene = preload("res://scenes/ui/options_menu.tscn")
var is_closing = false

func _ready():
	get_tree().paused = true
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)

	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	is_closing = true
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	get_tree().paused = false
	queue_free()


func on_resume_pressed():
	close()


func on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
