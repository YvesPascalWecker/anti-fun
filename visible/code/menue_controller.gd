class_name MenueController 
extends Control

@export_group("Scean Target")
@export var start_scean : PackedScene ##Inharitate the targetet Start Scene e.g. the first level
@export var option_scean : PackedScene  ##Inharitate the targetet Option Scene
@export_group("")


func _ready() -> void:
	if option_scean == null:
		$"AspectRatioContainer/V-SortStartMenue/OptionsButton".visible = false
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
