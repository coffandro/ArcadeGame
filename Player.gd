extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP

export var speed := Vector2(400.0, 500.0)
export var gravity := 35
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity: = Vector2.ZERO

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		velocity.x = speed.x
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed.x
	
	velocity.y += gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -speed.y
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)
