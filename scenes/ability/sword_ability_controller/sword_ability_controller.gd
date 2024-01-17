extends Node

@export var sword_ability: PackedScene

const MAX_RANGE = 150

@onready var timer: Timer = $Timer

var base_wait_time
var base_damage = 5
var additional_damage_percent = 1

func _ready():
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		return a.global_position.distance_squared_to(player.global_position) < b.global_position.distance_squared_to(player.global_position)
	)
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = calculate_damage()
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func calculate_damage():
	return base_damage * additional_damage_percent


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		"sword_rate":
			var percent_reduction = current_upgrades[upgrade.id]["quantity"] * .1
			timer.wait_time = base_wait_time * (1 - percent_reduction)
			timer.start()
		"sword_damage":
			additional_damage_percent = 1 + (.15 * current_upgrades[upgrade.id]["quantity"])
