extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float = 0.0):
	modulate = Color.TRANSPARENT
	if delay != 0.0:
		await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func play_discard():
	animation_player.play("discard")


func select_card():
	disabled = true
	animation_player.play("selected")
	
	for card in get_tree().get_nodes_in_group("upgrade_card"):
		if card is AbilityUpgradeCard and card != self:
			card.play_discard()
	
	await animation_player.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
	if event.is_action_pressed("left_click"):
		select_card()


func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
