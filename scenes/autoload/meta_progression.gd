extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"meta_upgrade_currency": 300,
	"meta_upgrades": {}
}

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	load_save_file()


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func get_meta_upgrade_currency() -> int:
	return save_data["meta_upgrade_currency"]


func get_meta_upgrade_quantity(id: String) -> int:
	return get_meta_upgrade_state(id).get("quantity", 0)


func get_meta_upgrade_state(id: String) -> Dictionary:
	return save_data["meta_upgrades"].get(id, {})


func update_meta_upgrade_currency(update_fn: Callable):
	var currency = update_fn.call(save_data["meta_upgrade_currency"])
	save_data["meta_upgrade_currency"] = currency
	save()


func add_meta_upgrade(upgrade: MetaUpgrade):
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {"quantity": 0}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()


func on_experience_vial_collected(number: float):
	save_data["meta_upgrade_currency"] += number
