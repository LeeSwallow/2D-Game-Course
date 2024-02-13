extends KinematicBody2D

# Evironment variable
var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 150
var HorizontalAcceleration = 1500
var jumpSpeed = 320
var jumpTerminationMultiplier =  3
var hasDoubleJump = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var moveVector = get_movement_vector()
	
	# 횡 이동 메카니즘
	velocity.x += moveVector.x * HorizontalAcceleration * delta
	if (moveVector.x == 0) :
		velocity.x = lerp(0, velocity.x, pow(2, -25 * delta))
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	# 종 이동 메카니즘 
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump)) :
		velocity.y = moveVector.y * jumpSpeed
		if (!is_on_floor() && $CoyoteTimer.is_stopped()) :
			hasDoubleJump = false
		$CoyoteTimer.stop()
	
	# 중력 
	if (velocity.y < 0 && !Input.is_action_pressed("jump")) : 
		# 강 점프
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else :
		# 소 점프
		velocity.y +=  gravity * delta
	
	# 코요테 타임
	var wasOnFloor = is_on_floor()
	
	# **가속도 메카니즘 갱신**
	velocity = move_and_slide(velocity, Vector2.UP) # 속도, 상하 지정 
	
	# 코요테 타이머 시작
	if(wasOnFloor && !is_on_floor()) :
		$CoyoteTimer.start()
	# 더블 점프 갱신
	if(is_on_floor()) :
		hasDoubleJump = true
	
	
	# **애니메이션 적용**
	update_animation()

# 입력 메카니즘 모듈화
func get_movement_vector():
		var moveVector = Vector2.ZERO
		moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		moveVector.y = (-1) if Input.is_action_just_pressed("jump") else 0
		return moveVector

func update_animation() :
	var moveVector = get_movement_vector()
	
	if(!is_on_floor()) :
		$AnimatedSprite.play("jump")#get_node("AninmatedSprite)
	elif (moveVector.x != 0) :
		$AnimatedSprite.play("run")
	else :
		$AnimatedSprite.play("idle")
	
	if(moveVector.x != 0) :
		$AnimatedSprite.flip_h = true if (moveVector.x > 0) else false
	
