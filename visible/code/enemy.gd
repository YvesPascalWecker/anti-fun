extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


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


func _on_area_3d_body_entered(body: Node3D) -> void:
	# The direction to the player body
	var direction = global_position.direction_to(body.global_position)
	
	# The location normalized of where the player is in relation to the Front
	# of the enemy
	var facing = global_transform.basis.tdotz(direction)
	
	var fov = cos(deg_to_rad(70))
	
	if facing > fov:
		print("Player has entered at" + facing)
		
	else:
		print("Where are you?!")


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("Player has left")
