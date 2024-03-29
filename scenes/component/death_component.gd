extends Node2D
class_name DeathComponent

@export var health_component: HealthComponent
@export var sprite: Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready():
	gpu_particles_2d.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	if not owner:
		return
	var spawn_position = owner.global_position
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities_layer.add_child(self)
	global_position = spawn_position
	animation_player.play("default")
	$HitRandomAudioPlayer.play_random()
