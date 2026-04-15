extends Node

@export var snake_scene : PackedScene

var score : int
var game_started : bool = false
var cells : int = 20
var cell_size : int = 50

var old_data : Array
var snake_data : Array
var snake : Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
