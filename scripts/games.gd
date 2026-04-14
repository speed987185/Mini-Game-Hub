extends Node2D

func _ready():
	$Fade_transition/AnimationPlayer.play("fade_out")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
