extends Node2D

@export var top_acceleration: float
@export var delta_acceleration: float

var direction: float = 0.0
var movement_speed: float = 0.0
var acceleration: float = 0.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	_get_input()
	_fall(delta)
	_move(delta)
	
func _move(delta: float) -> void:
	if direction != 0.0:
		_accelerate(delta)
	else:
		_deaccelerate(delta)
	
	print(movement_speed)
	position.x += movement_speed

func _accelerate(delta_time: float) -> void:
	if acceleration < top_acceleration:
		acceleration += delta_acceleration
	else:
		acceleration = top_acceleration
	
	movement_speed = (direction * acceleration * delta_time)
	
func _deaccelerate(delta_time: float) -> void:
	acceleration = 0.0
	movement_speed = 0.0

func _fall(delta_time: float) -> void:
	position.y += GlobalSettings._get_gravity() * delta_time
	
func _get_input() -> void:
	direction = Input.get_axis("left", "right")
