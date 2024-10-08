extends Camera2D

export(Color, RGB) var backgroundColor
export(OpenSimplexNoise) var shakeNoise

var targetPosition = Vector2.ZERO

var xNoiseSampleVector = Vector2.RIGHT
var yNoiseSampleVector = Vector2.DOWN
var xNoiseSamplePosition = Vector2.ZERO
var yNoiseSamplePosition = Vector2.ZERO

var noiseSampleTravelRate = 500
var maxShakeOffset = 10
var currentShakePercentage = 0
var shakeDecay = 3

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)
	apply_shake(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target_position()
	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))
	
	if (currentShakePercentage > 0):
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		var ySample = shakeNoise.get_noise_2d(yNoiseSamplePosition.x, yNoiseSamplePosition.y)
		
		var calculatedOffset = Vector2(xSample, ySample) * maxShakeOffset * pow(currentShakePercentage, 2)
		self.offset = calculatedOffset
		
		currentShakePercentage = clamp(currentShakePercentage - shakeDecay * delta, 0, 1)
		
func apply_shake(percentage):
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1)
	

func acquire_target_position() :
	if (set_target_position_from_node_group("player")):
		pass
	else :
		set_target_position_from_node_group("player_death")
	
func set_target_position_from_node_group(groupName) :
	var nodes = get_tree().get_nodes_in_group(groupName)
	var hasObject = (nodes.size() > 0)
	if(hasObject) :
		var node = nodes[0]
		targetPosition = node.global_position
	return hasObject	
