class_name PropagandaDecal
extends Area3D

@export var decalSwapTime = 1.0;
var flipState:bool = false

func flip() -> void:
	print("Called")
	print(flipState != !flipState)
	if flipState != !flipState:
		$"../../Enemy_Sticker".visible = !$"../../Enemy_Sticker".visible
		$"../../Player_Sticker".visible = !$"../../Player_Sticker".visible

func callToHome():
	#Global.countUpGoal()
	pass
