extends Area3D


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
