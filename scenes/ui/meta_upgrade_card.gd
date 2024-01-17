extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var cost_label: Label = %CostLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var purchase_button: Button = %PurchaseButton
@onready var count_label: Label = %CountLabel

var upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(meta_upgrade: MetaUpgrade):
	upgrade = meta_upgrade
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var upgrade_quantity = MetaProgression.get_meta_upgrade_quantity(upgrade.id)
	var is_maxed = upgrade_quantity >= upgrade.max_quantity
	count_label.text = "x%d" % upgrade_quantity
	cost_label.text = "%d/%d" % [MetaProgression.get_meta_upgrade_currency(), upgrade.experience_cost]
	progress_bar.value = min(1, float(MetaProgression.get_meta_upgrade_currency()) / float(upgrade.experience_cost))
	purchase_button.disabled = is_maxed or progress_bar.value != 1
	if is_maxed:
		purchase_button.text = "MAX"


func on_purchase_pressed():
	if upgrade == null:
		return
	MetaProgression.update_meta_upgrade_currency(func(currency): return currency - upgrade.experience_cost)
	MetaProgression.add_meta_upgrade(upgrade)
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play("purchase")
