class_name Game extends Node2D

@export var gravity: float = 10.0

@onready var player = $Player
@onready var root = $Level_Container
	
func _get_gravity() -> float:
	return gravity

func _load_level(name: String, pos_X: float, pos_Y: float) -> void:
	var level: Node2D = load("res://scenes/levels/" + name + ".tscn").instantiate()
	level.position = Vector2(pos_X, pos_Y)
	root.add_child(level)
