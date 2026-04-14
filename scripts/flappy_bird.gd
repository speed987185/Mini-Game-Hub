extends CharacterBody2D

const Flap = 200
const MAXFALLSPEED = 200
const GRAVITY = 10

var Wall = preload("res://scenes/flappy_wallnode.tscn")
var score = 0

func _physics_process(delta):
	velocity.y += GRAVITY
	
	if velocity.y > MAXFALLSPEED:
		velocity.y = MAXFALLSPEED
		
	if Input.is_action_just_pressed("flap"):
		velocity.y = -Flap
		
	move_and_slide()
	
	get_parent().get_parent().get_node("CanvasLayer/RichTextLabel").text = 0

func Wall_reset():
	var Wall_instance = Wall.instantiate()
	Wall_instance.position = Vector2(450, randf_range(-60.0, 60.0))
	get_parent().call_deferred("add_child", Wall_instance)

func _on_resetter_body_entered(body: Node2D) -> void:
	body.queue_free()
	Wall_reset()


func _on_detect_area_entered(area: Area2D) -> void:
	if area.name == "PointArea":
		score = score + 1
		

func _on_detect_body_entered(body: Node2D) -> void:
	if body.name == "Wall":
		get_tree().reload_current_scene()
