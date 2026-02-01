class_name enemy
extends CharacterBody3D


@export var audioStartHunting:Array[AudioStreamWAV]
@export var audioHunting:Array[AudioStreamWAV]
@export var audioPlayerVeryClose:Array[AudioStreamWAV]
@export var audioWalking:Array[AudioStreamWAV]
@export var FOV = 70.0
var playerIsVisible:bool = false
var player:Player
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum enemyState {Idle, Suspicious, Hunting}
var enemyStateCurrentValue:int = 0
var state:enemyState
var statePrevious:enemyState

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

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
				print("Hunting")
				
		statePrevious = state

func _on_player_flipping():
	setState(enemyState.Hunting)

func _process(delta: float) -> void:
	match state:
		enemyState.Idle:
			enemyStateCurrentValue = enemyState.Idle
			checkEnvironment()
		enemyState.Suspicious:
			enemyStateCurrentValue = enemyState.Suspicious
			pass
		enemyState.Hunting:
			enemyStateCurrentValue = enemyState.Hunting
			pass

func checkEnvironment() -> void:
	if player:
		# The direction to the player body
		var direction = global_position.direction_to(player.global_position)
		
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
		velocity += new_velocity
		move_and_slide()
	else: pass
