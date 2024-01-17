extends CharacterBody2D
class_name WizardEnemy

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_moving = false

func _ready():
	$HealthComponent.health_changed.connect(on_health_changed)


func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	velocity_component.move(self)
	sprite_2d.flip_h = velocity.x < 0


func set_is_moving(moving: bool):
	is_moving = moving


func on_health_changed():
	$HitRandomAudioPlayerComponent.play_random()
