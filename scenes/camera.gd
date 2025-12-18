extends Camera2D

@export var speed: float = 1.0
@export var max_position_diff: float = 200.0

@onready var player = $"../Player"

var in_position = true

func _ready() -> void:
	position.x = player.position.x

func _process(delta: float) -> void:
	var current_diff = position.x - player.position.x
	if abs(current_diff) > max_position_diff or not in_position:
		position.x += speed * current_diff * delta * -1
		in_position = true if position.x >= (player.position.x - 5.0) or position.x <= (player.position.x + 5.0) else false
