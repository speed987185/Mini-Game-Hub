extends Node

@export var snake_scene : PackedScene

var score : int = 0
var game_started : bool = false

var grid_width : int = 14
var grid_height : int = 8
var cell_size : int = 40

var snake_data : Array[Vector2] = []
var snake : Array = []  # Array of node instances

var move_direction : Vector2 = Vector2.DOWN
var can_move : bool = true

@onready var move_timer : Timer = $MoveTimer
@onready var score_label = $Hud.get_node("ScoreLabel")

func _ready() -> void:
	new_game()

func new_game() -> void:
	score = 0
	score_label.text = "Score: " + str(score)
	move_direction = Vector2.DOWN
	can_move = true
	game_started = false
	
	# Clear old snake if restarting
	for segment in snake:
		segment.queue_free()
	snake.clear()
	snake_data.clear()
	
	generate_snake()

func generate_snake() -> void:
	var pos = Vector2(13, 10)  # Better starting position in the middle (adjust if needed)
	for i in range(3):
		add_segment(pos)
		pos += Vector2.DOWN

func add_segment(pos: Vector2) -> void:
	snake_data.append(pos)
	var segment = snake_scene.instantiate()
	segment.position = pos * cell_size   # No extra + Vector2(0, cell_size) here
	add_child(segment)
	snake.append(segment)

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	if not can_move:
		return
	
	if Input.is_action_just_pressed("ui_down") and move_direction != Vector2.UP:
		move_direction = Vector2.DOWN
		can_move = false
		if not game_started:
			start_game()
			
	elif Input.is_action_just_pressed("ui_up") and move_direction != Vector2.DOWN:
		move_direction = Vector2.UP
		can_move = false
		if not game_started:
			start_game()
			
	elif Input.is_action_just_pressed("ui_left") and move_direction != Vector2.RIGHT:
		move_direction = Vector2.LEFT
		can_move = false
		if not game_started:
			start_game()
			
	elif Input.is_action_just_pressed("ui_right") and move_direction != Vector2.LEFT:
		move_direction = Vector2.RIGHT
		can_move = false
		if not game_started:
			start_game()

func start_game() -> void:
	game_started = true
	move_timer.start()

func _on_move_timer_timeout() -> void:
	# === ACTUAL MOVEMENT HAPPENS HERE ===
	can_move = true
	
	var old_data = snake_data.duplicate()  # Better than [] + array in GDScript 4
	
	# Move head
	snake_data[0] += move_direction
	
	# Move body
	for i in range(1, snake_data.size()):
		snake_data[i] = old_data[i - 1]
	
	# Update visual positions
	for i in range(snake.size()):
		snake[i].position = snake_data[i] * cell_size   # Clean position update
	
	# TODO: Later add food collision, wall collision, self-collision here
