extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.OnGameLost.connect(onGameLost)
	Global.OnGameWon.connect(onGameWon)
	pass # Replace with function body.

func onGameLost():
	text = "You lost!"
	Global.playerLiveState = false
func onGameWon():
	text = "You win!"
	Global.playerLiveState = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
