class_name enemy
extends CharacterBody3D


@export var audioStartHunting:Array[AudioStreamWAV]
@export var audioHunting:Array[AudioStreamWAV]
@export var audioPlayerVeryClose:Array[AudioStreamWAV]
@export var audioWalking:Array[AudioStreamWAV]
@export var FOV = 70.0
@export var rotateAround = 0.0
@export var rotateAroundDelay = 10.0
var rotateAroundDelayCurrent
var initialPosition:Vector3
var initialRotation:Vector3
@export var walkDistance = 10.0
var playerIsVisible:bool = false
var player:Player
@export_range(0.1, 2.0, 0.001) var speed = 2.0
@export var decelration = 0.05
@export var speedMin = 0.2
var speedCurrent:float
const JUMP_VELOCITY = 4.5

enum enemyState {Idle, Suspicious, Hunting, Returning}
var enemyStateCurrentValue:int = 0
var state:enemyState
var statePrevious:enemyState
var _velocity:Vector3

func _ready() -> void:
	initialPosition = global_position
	initialRotation = rotation
	rotateAroundDelayCurrent = rotateAroundDelay

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := _velocity
	if direction:
		velocity.x = direction.x * speedCurrent
		velocity.z = direction.z * speedCurrent
	else:
		velocity.x = move_toward(velocity.x, 0, speedCurrent)
		velocity.z = move_toward(velocity.z, 0, speedCurrent)

	move_and_slide()
	
func setState(newState:enemyState):
	if newState != state:
		state = newState
		match state:
			enemyState.Idle:
				print("Idling")
				$body.setState($body.BodyState.Idle)
				
			enemyState.Suspicious:
				print("Sus")
				$body.setState($body.BodyState.Suspicious)
				
			enemyState.Hunting:
				$body.setState($body.BodyState.Hunting)
				$AudioStreamPlayer3D.stream = audioStartHunting.pick_random()
				$AudioStreamPlayer3D.play()
				speedCurrent = speed
				print("Hunting")
				
			enemyState.Returning:
				pass
				
		statePrevious = state

func _on_player_flipping():
	setState(enemyState.Hunting)

func _process(delta: float) -> void:
	match state:
		enemyState.Idle:
			enemyStateCurrentValue = enemyState.Idle
			checkEnvironment(delta)
		enemyState.Suspicious:
			enemyStateCurrentValue = enemyState.Suspicious
			checkEnvironment(delta)
			pass
		enemyState.Hunting:
			enemyStateCurrentValue = enemyState.Hunting
			_velocity = global_position.direction_to(Global.player.global_position) * speed
			speedCurrent = max(speedCurrent - decelration * delta, speedMin)
			var rotationTarget = Global.player.global_position
			rotationTarget.y = global_position.y
			look_at(rotationTarget)
			if (initialPosition - global_position).length() > walkDistance:
				setState(enemyState.Returning)
				
			if (Global.player.global_position - global_position).length() < 1.5:
				Global.playerDied()
			pass
			
		enemyState.Returning:
			speedCurrent = min(speedCurrent + decelration * delta, speed)
			_velocity = global_position.direction_to(initialPosition) * speed
			var rotationTarget = initialPosition
			rotationTarget.y = global_position.y
			look_at(rotationTarget)
			#rotation = move_toward(rotation, angle_to_player, delta)
			
			if (global_position - initialPosition).length() < 1.0:
				setState(enemyState.Idle)
				_velocity = Vector3.ZERO
				rotation = initialRotation
			pass
			

func checkEnvironment(delta:float) -> void:
	rotateAroundDelayCurrent -= delta
	if rotateAroundDelayCurrent <= 0.0:
		rotateAroundDelayCurrent = rotateAroundDelay
		rotate_y(rad_to_deg(rotateAround))
		
	if player:
		# The direction to the player body
		#var direction = global_position.direction_to(player.global_position)
		var direction = player.global_position.direction_to(global_position)
		
		# The location normalized of where the player is in relation to the Front
		# of the enemy
		var facing = global_transform.basis.tdotz(direction)
		
		var fov = cos(deg_to_rad(FOV))
		
		if facing > fov:
			if !playerIsVisible:
				player.OnFlippingProgress.connect(_on_player_flipping)
				playerIsVisible = true;
			
		else:
			if playerIsVisible:
				playerIsVisible = false;
				player.OnFlippingProgress.disconnect(_on_player_flipping)

func _on_detect_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body		

func _on_detect_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
		print("Player has left")
		if playerIsVisible:
			playerIsVisible = false;
			body.OnFlippingProgress.disconnect(_on_player_flipping)


func _on_enemy_sub_code_velocity_persceadet(new_velocity: Vector3) -> void:
	if enemyStateCurrentValue == enemyState.Hunting:
		_velocity = new_velocity
	else: pass
