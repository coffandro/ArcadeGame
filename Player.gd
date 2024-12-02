extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP

export var speed := Vector2(400.0, 500.0)
export var gravity := 35
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity: = Vector2.ZERO
export var playerNumber: int = 1

func _ready():
	if playerNumber == 1:
		print("Player 1")
	elif playerNumber == 2:
		print("Player 2")
	else:
		print("The fuck you doing my duude?, playerNumber > 2")

func _physics_process(delta):
	if Input.is_action_pressed("move_right_p" + str(playerNumber)):
		velocity.x = speed.x
	if Input.is_action_pressed("move_left_p" + str(playerNumber)):
		velocity.x = -speed.x
	
	velocity.y += gravity
	
	if Input.is_action_just_pressed("jump_p" + str(playerNumber)) and is_on_floor():
		$StateLabel.text = "Jump"
		velocity.y = -speed.y
	elif Input.is_action_just_pressed("attack1_p" + str(playerNumber)):
		$StateLabel.text = "Attack1" + str(playerNumber)
	elif Input.is_action_just_pressed("attack2_p" + str(playerNumber)):
		$StateLabel.text = "Attack2" + str(playerNumber)
	elif Input.is_action_just_pressed("attack3_p" + str(playerNumber)):
		$StateLabel.text = "Attack3" + str(playerNumber)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.5)
	
	if velocity.x < 0.5 and velocity.x > -0.5:
		$MoveLabel.text = "Idle"
		$AnimatedSprite.playing = false
		$AnimatedSprite.animation = "Idle"
	elif velocity.x > 0:
		$MoveLabel.text = "Run Right"
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.playing = true
		$AnimatedSprite.animation = "Run"
	elif velocity.x < 0:
		$MoveLabel.text = "Run Left"
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.playing = true
		$AnimatedSprite.animation = "Run"
