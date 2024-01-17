extends Node

@export var basic_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer

const SPAWN_RADIUS = 375

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player")
	if !player:
		return Vector2.ZERO
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if result.is_empty():
			return spawn_position
		random_direction = random_direction.rotated(deg_to_rad(90))
	return Vector2.ZERO


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player")
	if !player:
		return
	
	var enemy_scene = enemy_table.pick_item() as PackedScene
	if not enemy_scene:
		return
	var enemy_instance = enemy_scene.instantiate()
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 15)
	if arena_difficulty == 18:
		enemy_table.add_item(bat_enemy_scene, 8)
	var time_off = .1 / 12 * arena_difficulty
	time_off = min(time_off, .7)
	timer.wait_time = base_spawn_time - time_off
