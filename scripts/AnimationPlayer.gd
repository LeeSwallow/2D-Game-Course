extends AnimationPlayer

var velocity = Vector2.ZERO

func _process(delta):
	velocity = move_and_slide(velocity)
	
	if()
