extends Node

var grid_pos : Vector2i
var board_size : int
var cell_size: int



func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(900, 600))
	board_size = $Board.texture.get_width()
	cell_size = board_size / 3
	


 
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < board_size:
				grid_pos = Vector2i(event.position / cell_size)
				print(grid_pos)
				
