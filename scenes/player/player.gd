class_name Player extends CharacterBody2D
## A simple script for the actions of a player character in a 2D platformer

##--------------------------------------------------------------------------------------------------
## Fields
##--------------------------------------------------------------------------------------------------
enum State {MOVING, JUMPING, FALLING}

@export var top_acceleration: float = 300.0		## Max acceleration on player's movement
@export var delta_acceleration: float = 15.0	## Change in acceleration on player's movement
@export var deacceleration_factor: float = 1.5
@export var midair_acceleration_factor: float = 0.5
@export var jump_speed: float = 450.0			## Speed for jumping

@onready var animated_sprite = $AnimatedSprite

var current_state: State = State.MOVING
var direction: float = 0.0				## Movement direction in X
var acceleration: float = 0.0			## Current acceleration to calculate movement speed
var acceleration_modifier = 1.0
var momentum_dir: float = 0.0			## Storages the movement direction before desacelerating

##--------------------------------------------------------------------------------------------------
## Functions
##--------------------------------------------------------------------------------------------------

func _process(_delta: float) -> void:
	print(current_state)
	_get_input()
	_jump()
	_move()
	_animate()

## ## 
## Process the movement of the character
## ##
func _move() -> void:
	## Fall speed based on current gravity
	velocity.y += GlobalSettings._get_gravity()
	
	if current_state == State.JUMPING:
		if direction == momentum_dir:
			_accelerate()	
		elif direction == 0.0:
			direction = momentum_dir
			_accelerate()
		else:
			velocity.y = 0.0
			current_state = State.FALLING
	elif is_on_floor():
		current_state = State.MOVING
		acceleration_modifier = 1.0
		
		## Calculates speed in X base on current input
		if direction != 0.0:
			_accelerate()
			momentum_dir = direction
		else:
			_deaccelerate()
	elif current_state == State.FALLING:
		acceleration_modifier = midair_acceleration_factor
		_accelerate()
	else:
		current_state = State.FALLING
	
	## Let the engine move and collide
	move_and_slide()

## ##
## Calculates speed in X base on the directional input of the user
## ##
func _accelerate() -> void:
	if acceleration < (top_acceleration * acceleration_modifier):
		acceleration += delta_acceleration
	else:
		acceleration = (top_acceleration * acceleration_modifier)
	
	velocity.x = direction * acceleration * acceleration_modifier

## ##
## Gradually stops the player if there is no input from the user
## ##
func _deaccelerate() -> void:
	if acceleration > 0.0:
		acceleration -= (delta_acceleration*deacceleration_factor)
		velocity.x = momentum_dir * acceleration
	else:
		momentum_dir = 0.0
		velocity.x = 0.0

## ##
## Controls the actions of the player while jumping
## ##
func _jump() -> void:
	if current_state == State.JUMPING:
		if is_on_floor():
			velocity.y = jump_speed * -1
			animated_sprite.play("Jump")
		elif velocity.y > 0.0:
			current_state = State.FALLING
	elif current_state == State.FALLING:
		if is_on_floor():
			current_state = State.MOVING
	
## ##
## Detects current input of the user
## ##
func _get_input() -> void:
	direction = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		current_state = State.JUMPING
	
func _animate() -> void:
	if is_on_floor():
		if direction > 0.0: animated_sprite.play("Right")
		elif direction < 0.0: animated_sprite.play("Left")
		else: animated_sprite.play("Idle")
