extends CanvasLayer
class_name EndScreen

@onready var continue_button: Button = %ContinueButton
@onready var quit_button: Button = %QuitButton
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var panel_container: PanelContainer = %PanelContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var defeat_jingle = preload("res://assets/audio/jingles_defeat.ogg")

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_callback(play_jingle)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func play_jingle():
	$AudioStreamPlayer.play()


func set_defeat():
	audio_stream_player.stream = defeat_jingle
	title_label.text = "Defeat"
	description_label.text = "You died!"


func on_continue_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func on_quit_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
