extends Node
@export var parrent:CharacterBody3D
@onready var playerPosition : Vector3

signal velocity_persceadet(new_velocity:Vector3, targetPos:Vector3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fake_pathfinging(playerPosition,delta)
	pass

func get_playerPosition(delta) -> Vector3:
	return Global.player.global_position

func fake_pathfinging(targetPos:Vector3, delta:float) -> void:
	var new_velocity: Vector3 = parrent.global_position.direction_to(targetPos)*5.0 *delta
	emit_signal("velocity_persceadet", new_velocity, targetPos)
