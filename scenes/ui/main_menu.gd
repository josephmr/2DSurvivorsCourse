extends CanvasLayer

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var upgrades_button: Button = %UpgradesButton

var options_scene = preload("res://scenes/ui/options_menu.tscn")

func _ready():
	play_button.pressed.connect(on_play_pressed)
	upgrades_button.pressed.connect(on_upgrades_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_instance = options_scene.instantiate()
	add_child(options_instance)


func on_upgrades_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func on_quit_pressed():
	get_tree().quit()
