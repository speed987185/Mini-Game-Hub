extends Node2D

var button_type = null


func _ready():
	$Fade_transitions/AnimationPlayer.play("fade_out")

func _on_back_pressed() -> void:
	button_type = "back"
	$Fade_transitions2.show()
	$Fade_transitions2/Fade_timer.start()
	$Fade_transitions2/AnimationPlayer.play("fade_in")
	
func _on_flappy_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flappy_world.tscn")



func _on_fade_timer_timeout() -> void:
	if button_type == "back":
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_tic_tac_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tic_tac_toe.tscn")
