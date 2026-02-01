extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.OnRemainingDecalCountChanged.connect(decalCountChanged)
	pass # Replace with function body.

func decalCountChanged(countNew:int, countTotal:int):
	text = str(countTotal - countNew) + "/" + str(countTotal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
