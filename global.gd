extends Node

@export var positiveDecalTextures:Array[Texture2D]
@export var negativeDecalTextures:Array[Texture2D]
var __remainingDecalCount:int
var __decalCountTotal:int

signal OnRemainingDecalCountChanged(countNew:int, countTotal:int)
signal OnGameLost(count:int, countTotal:int)
signal OnGameWon()

func setRemainingDecalCount(count:int):
	__remainingDecalCount = count;
	OnRemainingDecalCountChanged.emit(__remainingDecalCount, __decalCountTotal)
	if __remainingDecalCount <= 0:
		OnGameWon.emit()
		print("Game won!")
		
	
func getRemainingDecalCount():
	return __remainingDecalCount
	
func registerDecal():
	__decalCountTotal += 1
	setRemainingDecalCount(__remainingDecalCount + 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
