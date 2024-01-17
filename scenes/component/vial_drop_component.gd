extends Node
class_name VialDropComponent

@export_range(0, 1) var drop_percent: float = .5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene

func _ready():
	health_component.died.connect(on_died)


func on_died():
	var adjusted_drop_percent = drop_percent * (1 + .1 * MetaProgression.get_meta_upgrade_quantity("experience_gain"))
	if vial_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	if randf() > adjusted_drop_percent:
		return
	
	var vial_instance = vial_scene.instantiate()
	vial_instance.global_position = owner.global_position
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
