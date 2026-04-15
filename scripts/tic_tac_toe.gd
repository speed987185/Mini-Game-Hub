extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var player : int = 1
var temp_marker : Node
var player_panel_pos : Vector2i
var grid_data : Array = [[0,0,0], [0,0,0], [0,0,0]]
var board_size : int
var cell_size : int

@onready var game_over_panel = $tictactoe_game_over
@onready var result_label = $tictactoe_game_over/ResultLabel

func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(900, 600))
	board_size = $Board.texture.get_width()
	cell_size = board_size / 3
	player_panel_pos = $Side_panel.get_position() as Vector2i
	
	new_game()


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if event.position.x < board_size and event.position.y < board_size:
			var grid_pos = Vector2i(event.position / cell_size)
			
			if grid_pos.x < 3 and grid_pos.y < 3:
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					# marker
					grid_data[grid_pos.y][grid_pos.x] = player
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size/2, cell_size/2))
					
					# win check
					var win_result = check_win()
					if win_result != 0:
						show_game_over(win_result)
						return
					
					# Switch player
					player *= -1
					
					# Update cross or circle
					if temp_marker:
						temp_marker.queue_free()
					create_marker(player, player_panel_pos + Vector2i(cell_size/2, cell_size/2), true)


func new_game() -> void:
	player = 1
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]
	
	if temp_marker:
		temp_marker.queue_free()
	
	create_marker(player, player_panel_pos + Vector2i(cell_size/2, cell_size/2), true)
	game_over_panel.hide()


func create_marker(player: int, position: Vector2i, temp: bool = false) -> void:
	if temp_marker and temp:
		temp_marker.queue_free()
	
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		if temp:
			temp_marker = circle
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if temp:
			temp_marker = cross


func check_win() -> int:
	for i in 3:
		# Row
		var row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		# Column
		var col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		
		if row_sum == 3 or col_sum == 3:
			return 1
		elif row_sum == -3 or col_sum == -3:
			return -1
	
	# Diagonals
	var diagonal1 = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
	var diagonal2 = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]
	
	if diagonal1 == 3 or diagonal2 == 3:
		return 1
	elif diagonal1 == -3 or diagonal2 == -3:
		return -1
	
	return 0


func show_game_over(winner: int) -> void:
	get_tree().paused = true
	game_over_panel.show()
	
	if winner == 1:
		result_label.text = "Player 1 Wins!"
	elif winner == -1:
		result_label.text = "Player 2 Wins!"
	else:
		result_label.text = "It's a Draw!" 
