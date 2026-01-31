extends Node3D


var flipState:bool = false

func flip() -> void:
	if flipState != flipState:
		%Enemy_Sticker.visible =!%Enemy_Sticker.visibl
		%Player_Sticker.visible =!%Player_Sticker.visibl

func callToHome():
	#Global.countUpGoal()
	pass
