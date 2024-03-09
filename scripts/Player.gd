extends KinematicBody2D

# Evironment variable
signal died

enum State { NORMAL, DASHING }

export(int, LAYERS_2D_PHYSICS) var dashHazardMask

var playerDeathScene = preload("res://scenes/PlayerDeath.tscn")

var gravity = 1000
var velocity = Vector2.ZERO

var maxHorizontalSpeed = 150
var minDashSpeed = 200
var maxDashSpeed = 500
var HorizontalAcceleration = 1500
var jumpSpeed = 320

var jumpTerminationMultiplier =  3
var hasDoubleJump = false
var hasDash = false
var isStateNew = true
var isDying = false

var currentState = State.NORMAL
var defaultHazardMask = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	defaultHazardMask = $HazardArea.collision_mask

func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
	isStateNew = false
	
func change_state(newState):
	currentState = newState
	isStateNew = true
	

# normal 상태 모듈화
func process_normal(delta):
	if (isStateNew):
		$DashParticles.emitting = false
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
		
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
			$"/root/Helper".apply_camera_shake(.75)		
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

	# 플레이어가 땅위에 있을 때 초기화
	if(is_on_floor()) :
		hasDoubleJump = true
		hasDash = true
			
	# 대시 상태 확인 & 실행
	if(hasDash && Input.is_action_just_pressed("dash")):
		call_deferred("change_state", State.DASHING)
		hasDash = false
	
	# **애니메이션 적용**
	update_animation()

# 대쉬 상태 구현
func process_dash(delta):
	if (isStateNew):
		$DashParticles.emitting = true
		$"/root/Helper".apply_camera_shake(.75)
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask = dashHazardMask
		
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if (moveVector.x != 0) :
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1


		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	
	if (abs(velocity.x) < minDashSpeed) :
		call_deferred("change_state", State.NORMAL)

# 입력 메카니즘 모듈화
func get_movement_vector():
		var moveVector = Vector2.ZERO
		moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		moveVector.y = (-1) if Input.is_action_just_pressed("jump") else 0
		return moveVector

# 캐릭터 애니매이션 모듈화
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
	
func kill():
	if (isDying):
		return
		
	isDying = true
	
	var playerDeathInstance = playerDeathScene.instance()
	playerDeathInstance.velocity = velocity
	get_parent().add_child_below_node(self, playerDeathInstance)
	playerDeathInstance.global_position = global_position
	emit_signal("died")
	

# 플레이어 die 모듈화
func on_hazard_area_entered(area2d) :
	$"/root/Helper".apply_camera_shake(1)
	call_deferred("kill")

	
	
	
