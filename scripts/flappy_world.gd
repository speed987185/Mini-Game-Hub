extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fade_transitions2/AnimationPlayer.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	pass
	
