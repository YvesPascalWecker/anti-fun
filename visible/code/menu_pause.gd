class_name MenueController 
extends Control


func _ready() -> void:
	%SplashScreen.visible = true
	%"V-SortStartMenue".visible = false


func _process(_delta: float) -> void:
	if %SplashScreen.visible and Input.is_anything_pressed():
		%SplashScreen.visible = false
		%"V-SortStartMenue".visible = true


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(start_scean.resource_path)


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file(option_scean.resource_path)


func _on_end_button_pressed() -> void:
	get_tree().quit()
