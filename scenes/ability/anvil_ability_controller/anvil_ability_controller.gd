extends Node

@export var anvil_ability_scene: PackedScene

const MAX_RANGE = 200
var base_damage = 5

func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemy") as Array[Node2D]
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		return
	enemies = enemies.filter(func(enemy: Node2D): return player.global_position.distance_squared_to(enemy.global_position) <= pow(MAX_RANGE, 2))
	var target_enemy = enemies.pick_random() as Node2D
	if not target_enemy:
		return
	var anvil_instance = anvil_ability_scene.instantiate() as AnvilAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(anvil_instance)
	anvil_instance.global_position = target_enemy.global_position
	anvil_instance.hitbox_component.damage = base_damage
	
