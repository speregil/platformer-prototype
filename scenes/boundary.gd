class_name Boundary extends Area2D

enum exit_type {LEFT,RIGHT,TOP,BOTTOM}

@export var load_level: String
@export var type: exit_type

var game_manager: Game

func _ready() -> void:
	game_manager = get_tree().root.get_node("Game")
	
func _on_body_entered(body: Node2D) -> void:
	var pos_X = 0.0
	var pos_Y = 0.0
	if type == exit_type.LEFT: pos_X = -1920
	elif type == exit_type.RIGHT: pos_X = 1920
	elif type == exit_type.TOP: pos_Y = -1080
	elif  type == exit_type.BOTTOM: pos_Y = 1080
	
	game_manager._load_level(load_level, pos_X, pos_Y)
