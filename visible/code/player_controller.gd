class_name Player
extends CharacterBody3D


@export var speed:float = 5.0
@export var progressBarScene:PackedScene
var progressBarInstance:Object
var progressBarComponent
var decalProgress:float
@export_range(0.00001,1.0,0.00001) var mouse_sensitivity:float = 0.0
var decal:Area3D
var isFlippingDecal:bool
const JUMP_VELOCITY:float = 4.5

signal OnFlippingProgress
signal OnFlippingDone


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	progressBarInstance = progressBarScene.instantiate()
	progressBarComponent = progressBarInstance.get_child(0)
	progressBarComponent.value = 0.0
	%Head.add_child(progressBarInstance)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		%Head.rotate_x(-event.relative.y * mouse_sensitivity)
		%Head.rotation.x = clampf(%Head.rotation.x, -deg_to_rad(70), deg_to_rad(70))

	if Input.is_action_just_pressed("interact"):
		#var collidetWith = %ArmEyeCast.get_collider()
		#print(collidetWith.name)
		if decal:
			isFlippingDecal = true
			decalProgress = decal.decalSwapTime
		#if collidetWith.name == "DecalArea3D":
		#	if collidetWith.has_method("flip"):
		#		collidetWith.flip()
		#		collidetWith.decalSwapTime
	elif Input.is_action_just_released("interact"):
		isFlippingDecal = false
		progressBarComponent.value = 0.0
	
func _process(delta: float) -> void:
	var collidetWith = %ArmEyeCast.get_collider()
	if collidetWith && collidetWith is PropagandaDecal:
		decal = collidetWith
		decal.setHighlight(true)
		if isFlippingDecal && decal:
			# Add flipping progress
			decalProgress -= delta
			progressBarComponent.value = ((decal.decalSwapTime - decalProgress) / decal.decalSwapTime)
			OnFlippingProgress.emit()
			if decalProgress <= 0.0:
				decal.flip()
				decal.setHighlight(false)
				isFlippingDecal = false
				OnFlippingDone.emit()
			
		else:
			# Cancel flipping action
			isFlippingDecal = false
			progressBarComponent.value = 0.0
	else:
		# Cancel flipping action
		if decal:
			decal.setHighlight(false)
			decal = null
		
		isFlippingDecal = false
		progressBarComponent.value = 0.0
		
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
