extends Camera2D

const SMOOTHING = 20

var target_position = Vector2.ZERO

func _ready():
	make_current()


func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		target_position = player.global_position
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * SMOOTHING))
