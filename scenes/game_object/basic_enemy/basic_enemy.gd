extends CharacterBody2D

const MAX_SPEED = 40

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent

func _ready():
	health_component.health_changed.connect(on_health_changed)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	sprite_2d.flip_h = velocity.x > 0


func on_health_changed():
	$HitRandomAudioPlayerComponent.play_random()
