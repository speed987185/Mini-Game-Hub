extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var player : int
var grid_data : Array
var grid_pos : Vector2i
var board_size : int
var cell_size: int



func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(900, 600))
	board_size = $Board.texture.get_width()
	cell_size = board_size / 3
	new_game()
 
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < board_size:
				grid_pos = Vector2i(event.position / cell_size)
				if grid_data[grid_pos.y][grid_pos.x]  == 0:
					grid_data[grid_pos.y][grid_pos.x] = player
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size/ 2 , cell_size/2))
					
					player *= -1
					print(grid_data)
				
func new_game():
	player = 1
	grid_data = [
		[0,0,0], 
		[0,0,0],
		[0,0,0]
		]
		
func create_marker(player, position):
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
