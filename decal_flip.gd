@tool

class_name PropagandaDecal
extends Area3D

@export var decalSwapTime = 1.0
@export var decalTextureEnemy:Texture2D
@export var decalTexturePlayer:Texture2D
@export var isNegative:bool = true
@export var playerDecalOffset:Vector3
@export var playerDecalRotation:float = -180.0
@export var playerDecalScale:Vector3 = Vector3(0.5, 0.5, 0.5)


var __decalTextureEnemyLast:Texture2D
var __decalTexturePlayerLast:Texture2D
var __isNegativeLast:bool
var __playerDecalOffsetLast:Vector3
var __playerDecalRotationLast:float
var __playerDecalScaleLast:Vector3

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if decalTexturePlayer != __decalTexturePlayerLast or decalTextureEnemy != __decalTextureEnemyLast or isNegative != __isNegativeLast or __playerDecalOffsetLast != playerDecalOffset or __playerDecalScaleLast != playerDecalScale or __playerDecalRotationLast != playerDecalRotation:
			__decalTextureEnemyLast = decalTextureEnemy
			__decalTexturePlayerLast = decalTexturePlayer
			__isNegativeLast = isNegative
			__playerDecalOffsetLast = playerDecalOffset
			__playerDecalScaleLast = playerDecalScale
			__playerDecalRotationLast = playerDecalRotation
			updateDecal()

func _ready() -> void:
	if !Engine.is_editor_hint():
		Global.registerDecal()
		updateDecal()

func updateDecal():
	%Player_Sticker.visible = !isNegative
	if decalTextureEnemy.get_rid():
		print(%Enemy_Sticker)
		%Enemy_Sticker.texture_albedo = decalTextureEnemy
		%Player_Sticker.texture_albedo = decalTexturePlayer
		print(decalTextureEnemy.get_height())
		print(decalTextureEnemy.get_width())
		var texSize = decalTextureEnemy.get_size()
		%Enemy_Sticker.size = Vector3(1.0, 1.0, texSize.y/texSize.x)
		%Player_Sticker.rotation.z = playerDecalRotation
		%Player_Sticker.position = playerDecalOffset
		%Player_Sticker.scale = playerDecalScale
				
func flip() -> void:
	isNegative = !isNegative
	if isNegative:
		Global.setRemainingDecalCount(Global.getRemainingDecalCount() + 1)
	else:
		Global.setRemainingDecalCount(Global.getRemainingDecalCount() - 1)
	updateDecal()
		

func callToHome():
	#Global.countUpGoal()
	pass
