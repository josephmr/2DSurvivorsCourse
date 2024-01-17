extends Node
class_name HealthComponent

signal died
signal health_changed
signal hit

@export var max_health: float = 10

var current_health: float

func _ready() -> void:
	current_health = max_health


func heal(heal_amount: float) -> void:
	if heal_amount <= 0:
		return
	current_health = min(max_health, current_health + heal_amount)
	health_changed.emit()


func damage(damage_amount: float) -> void:
	if damage_amount <= 0:
		return
	current_health = max(0, current_health - damage_amount)
	hit.emit()
	health_changed.emit()
	check_death.call_deferred()


func get_health_percent() -> float:
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death() -> void:
	if current_health == 0:
		died.emit()
		owner.queue_free()
