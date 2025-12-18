class_name Game extends Node2D

@export var gravity: float = 10.0

@onready var _player = $Player

func _get_gravity() -> float:
	return gravity
