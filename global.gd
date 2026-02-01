extends Node

@export var positiveDecalTextures:Array[Texture2D]
@export var negativeDecalTextures:Array[Texture2D]
var __remainingDecalCount:int

func setRemainingDecalCount(count:int):
	__remainingDecalCount = count;
	
func getRemainingDecalCount():
	return __remainingDecalCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
