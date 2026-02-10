extends Node3D

enum BodyState {Idle, Suspicious, Angry, Hunting}
var state:BodyState
var statePrevious:BodyState

func setState(newState:BodyState):
	if newState != state:
		state = newState
		$bat.visible = false
		$face_normal.visible = false
		$face_angry.visible = false
		$face_happy.visible = false
		$face_suspicious.visible = false
		
		match state:
			BodyState.Idle:
				$face_normal.visible = true
			BodyState.Suspicious:
				$face_suspicious.visible = true
			BodyState.Angry:
				$face_angry.visible = true
			BodyState.Hunting:
				$face_angry.visible = true
				$bat.visible = true
		
		statePrevious = state
				

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
