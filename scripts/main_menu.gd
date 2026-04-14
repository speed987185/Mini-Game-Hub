extends Node2D

var button_type = null


func _on_games_pressed() -> void:
	button_type = "games"
	$Fade_transitions.show()
	$Fade_transitions/Fade_timer.start()
	$Fade_transitions/AnimationPlayer.play("fade_in")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "games":
		get_tree().change_scene_to_file("res://scenes/games.tscn")
