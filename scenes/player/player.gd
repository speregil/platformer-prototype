class_name Player extends CharacterBody2D
## A simple script for the actions of a player character in a 2D platformer

##--------------------------------------------------------------------------------------------------
## Fields
##--------------------------------------------------------------------------------------------------

@export var top_acceleration: float		## Max acceleration on player's movement
@export var delta_acceleration: float	## Change in acceleration on player's movement
@export var jump_speed: float			## Speed for jumping

@onready var animated_sprite = $AnimatedSprite

var direction: float = 0.0				## Movement direction in X
var acceleration: float = 0.0			## Current acceleration to calculate movement speed
var momentum_dir: float = 0.0			## Storages the movement direction before desacelerating
var is_jumping: bool = false			## Determines if the player is jumping or not

##--------------------------------------------------------------------------------------------------
## Functions
##--------------------------------------------------------------------------------------------------

func _process(_delta: float) -> void:
	_get_input()
	if is_jumping: _jump()
	_move()
	_animate()

## ## 
## Process the movement of the character
## ##
func _move() -> void:
	## Fall speed based on current gravity
	velocity.y += GlobalSettings._get_gravity()
	
	## Calculates speed in X base on current input
	if direction != 0.0:
		_accelerate()
		momentum_dir = direction
	else:
		_deaccelerate()
	
	## Let the engine move and collide
	move_and_slide()

## ##
## Calculates speed in X base on the directional input of the user
## ##
func _accelerate() -> void:
	if acceleration < top_acceleration:
		acceleration += delta_acceleration
	else:
		acceleration = top_acceleration
	
	velocity.x = direction * acceleration

## ##
## Gradually stops the player if there is no input from the user
## ##
func _deaccelerate() -> void:
	if acceleration > 0.0:
		acceleration -= (delta_acceleration*1.5)
		velocity.x = momentum_dir * acceleration
	else:
		momentum_dir = 0.0
		velocity.x = 0.0

## ##
## Controls the actions of the player while jumping
## ##
func _jump() -> void:
	if(is_on_floor()):
		velocity.y = jump_speed * -1
		animated_sprite.play("Jump")
	else:
		is_jumping = false
	
## ##
## Detects current input of the user
## ##
func _get_input() -> void:
	direction = Input.get_axis("left", "right")
	is_jumping = Input.is_action_just_pressed("jump")
	
func _animate() -> void:
	if is_on_floor():
		if direction > 0.0: animated_sprite.play("Right")
		elif direction < 0.0: animated_sprite.play("Left")
		else: animated_sprite.play("Idle")
