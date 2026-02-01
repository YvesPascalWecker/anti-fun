extends Node
@export var parrent:CharacterBody3D

signal velocity_persceadet(new_velocity:Vector3, targetPos:Vector3,delta:float)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fake_pathfinging(parrent.global_position,delta)


func fake_pathfinging(targetPos:Vector3, delta:float) -> void:
	var new_velocity: Vector3 = parrent.global_position.direction_to(targetPos)*5.0 *delta
	emit_signal("velocity_persceadet", new_velocity, targetPos, delta)
