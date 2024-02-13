extends Camera2D
export(Color, RGB) var backgroundColor

var targetPosition = Vector2.ZERO

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target_position()
	global_position = lerp(targetPosition, global_position, pow(2, -50 * delta))

func acquire_target_position() :
	var players = get_tree().get_nodes_in_group("player")
	if(players.size() > 0) :
		var player = players[0]
		targetPosition = player.global_position
	
