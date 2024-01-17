extends CharacterBody2D
class_name Player

@onready var abilities: Node = $Abilities
@onready var collision_area_2d: Area2D = $CollisionArea2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_regen_timer: Timer = $HealthRegenTimer

@onready var base_max_speed = velocity_component.max_speed

var colliding_bodies: int = 0

func _ready() -> void:
	collision_area_2d.body_entered.connect(on_body_entered)
	collision_area_2d.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	health_component.hit.connect(on_hit)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	if MetaProgression.get_meta_upgrade_quantity("health_regen") > 0:
		health_regen_timer.start()
		health_regen_timer.timeout.connect(on_health_regen_timer_timeout)
	update_health_bar()


func _process(delta: float) -> void:
	var direction = get_movement_vector()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	if direction.x != 0 or direction.y != 0:
		animation_player.play("walk")
		sprite_2d.flip_h = direction.x < 0
	else:
		animation_player.play("RESET")


func get_movement_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func check_deal_damage() -> void:
	if colliding_bodies == 0 || not damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_bar() -> void:
	health_bar.value = health_component.get_health_percent()


func on_health_regen_timer_timeout():
	health_component.heal(1)


func on_body_entered(other_body: Node2D) -> void:
	colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D) -> void:
	colliding_bodies -= 1


func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func on_hit():
	GameEvents.emit_player_damaged()
	$HitRandomStreamPlayerComponent.play_random()


func on_health_changed() -> void:
	update_health_bar()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade is Ability:
		abilities.add_child((upgrade as Ability).ability_controller_scene.instantiate())
	
	match upgrade.id:
		"move_speed":
			velocity_component.max_speed = base_max_speed * (1 + .1 * current_upgrades[upgrade.id]["quantity"])

