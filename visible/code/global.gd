extends Node

@export var positiveDecalTextures:Array[Texture2D]
@export var negativeDecalTextures:Array[Texture2D]
var __remainingDecalCount:int
var __decalCountTotal:int
var player:Player
var playerLiveState:bool = true

signal OnRemainingDecalCountChanged(countNew:int, countTotal:int)
signal OnGameLost(count:int, countTotal:int)
signal OnGameWon()

func setRemainingDecalCount(count:int):
	__remainingDecalCount = count;
	OnRemainingDecalCountChanged.emit(__remainingDecalCount, __decalCountTotal)
	if __remainingDecalCount <= 0:
		OnGameWon.emit()
		
	
func getRemainingDecalCount():
	return __remainingDecalCount
	
func playerDied() -> void:
	OnGameLost.emit()
	
func registerDecal() -> void:
	__decalCountTotal += 1
	setRemainingDecalCount(__remainingDecalCount + 1)

func is_player_alive():
	return playerLiveState
