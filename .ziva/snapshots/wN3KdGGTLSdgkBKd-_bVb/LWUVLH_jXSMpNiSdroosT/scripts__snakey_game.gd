extends Node
class_name SnakeyGame

@export var snake_scene: PackedScene
@export var fruit_scene: PackedScene = preload("res://scenes/fruit.tscn")

const CELL_SIZE: int = 40

var score: int = 0
var game_started: bool = false

var grid_width: int = 0
var grid_height: int = 0

var snake_data: Array[Vector2] = []
var snake: Array[Panel] = []

var move_direction: Vector2 = Vector2.DOWN
var can_move: bool = true

var fruit_data: Vector2 = Vector2.ZERO
var fruit_node: Node = null

@onready var move_timer: Timer = $MoveTimer
@onready var score_label: Label = $Hud/ScoreLabel
@onready var game_over_ui: CanvasLayer = $Snake_game_over
@onready var result_label: Label = $Snake_game_over/ResultLabel
@onready var reset_button: Button = $Snake_game_over/Reset
@onready var home_button: Button = $Snake_game_over/home
@onready var grid_panel: Panel = $Panel

func _ready() -> void:
	randomize()
	grid_width = max(1, int(grid_panel.rect_size.x / CELL_SIZE))
	grid_height = max(1, int(grid_panel.rect_size.y / CELL_SIZE))
	game_over_ui.visible = false
	reset_button.pressed.connect(_on_reset_pressed)
	home_button.pressed.connect(_on_home_pressed)
	new_game()

func new_game() -> void:
	move_timer.stop()
	score = 0
	_update_score_label()
	move_direction = Vector2.DOWN
	can_move = true
	game_started = false

	for segment in snake:
		segment.queue_free()
	snake.clear()
	snake_data.clear()

	if fruit_node:
		fruit_node.queue_free()
	fruit_node = null

	generate_snake()
	spawn_fruit()

func generate_snake() -> void:
	var segment_count = min(3, grid_height)
	var max_start_y = max(grid_height - segment_count, 0)
	var start_x = clamp(int(grid_width / 2), 0, max(grid_width - 1, 0))
	var start_y = clamp(int(grid_height / 2), 0, max_start_y)
	var pos = Vector2(start_x, start_y)
	for i in range(segment_count):
		add_segment(pos)
		pos += Vector2.DOWN

func add_segment(pos: Vector2) -> void:
	snake_data.append(pos)
	var segment: Panel = snake_scene.instantiate() as Panel
	segment.position = pos * CELL_SIZE
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
	can_move = true
	var old_data = snake_data.duplicate()

	snake_data[0] += move_direction
	for i in range(1, snake_data.size()):
		snake_data[i] = old_data[i - 1]

	for i in range(snake.size()):
		snake[i].position = snake_data[i] * CELL_SIZE

	if snake_data[0] == fruit_data:
		add_segment(old_data[old_data.size() - 1])
		score += 1
		_update_score_label()
		spawn_fruit()

	if is_out_of_bounds(snake_data[0]) or is_self_collision():
		show_game_over()

func spawn_fruit() -> void:
	var free_cells: Array[Vector2] = []
	for x in range(grid_width):
		for y in range(grid_height):
			var cell = Vector2(x, y)
			if not snake_data.has(cell):
				free_cells.append(cell)
	if free_cells.is_empty():
		return
	fruit_data = free_cells[randi() % free_cells.size()]
	if fruit_node:
		fruit_node.queue_free()
	fruit_node = fruit_scene.instantiate()
	fruit_node.position = fruit_data * CELL_SIZE
	add_child(fruit_node)

func _update_score_label() -> void:
	score_label.text = "Score: %d" % score

func show_game_over() -> void:
	move_timer.stop()
	can_move = false
	game_started = false
	result_label.text = "Game Over\nScore: %d" % score
	game_over_ui.visible = true

func _on_reset_pressed() -> void:
	game_over_ui.visible = false
	new_game()

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func is_out_of_bounds(head_pos: Vector2) -> bool:
	return head_pos.x < 0 or head_pos.x >= grid_width or head_pos.y < 0 or head_pos.y >= grid_height

func is_self_collision() -> bool:
	for i in range(1, snake_data.size()):
		if snake_data[i] == snake_data[0]:
			return true
	return false
