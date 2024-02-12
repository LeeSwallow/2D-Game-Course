extends KinematicBody2D

# Evironment variable
var gravity = 300
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 100
var HorizontalAcceleration = 400
var jumpSpeed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	# 입력 메카니즘
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = (-1) if Input.is_action_just_pressed("jump") else 0
	
	# 횡 이동 메카니즘
	velocity.x = moveVector.x * HorizontalAcceleration * delta
	if (moveVector.x == 0) :
		velocity = lerp(0, velocity.x, pow(2, -delta))
	
	velocity.x = clamp(velocity.x, -(maxHorizontalSpeed), maxHorizontalSpeed)
	
	# 종 이동 메카니즘 
	if (moveVector.y < 0 && is_on_floor()) :
		velocity.y = moveVector.y * jumpSpeed
	
	velocity.y +=  gravity * delta # 중력
	
	velocity = move_and_slide(velocity, Vector2.UP) # 속도, 상하 지정 
