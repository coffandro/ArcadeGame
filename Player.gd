extends KinematicBody2D

onready var LevelState = get_node("/root/LevelState")
const FLOOR_NORMAL := Vector2.UP

export var speed := Vector2(400.0, 500.0)
export var gravity := 35
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity: = Vector2.ZERO
export var playerNumber: int = 1

export(PackedScene) var Bullet
onready var StateLabel = $StateLabel
onready var MoveLabel = $MoveLabel
onready var animatedSprite = $AnimatedSprite
var facing = 1

func _ready():
	if playerNumber == 1:
		print("Player 1")
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(1, true)
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, true)
	elif playerNumber == 2:
		print("Player 2")
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(1, false)
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, false)
	else:
		print("The fuck you doing my duude?, playerNumber > 2")
	
	#get_node("/root/GlobalCamera").add_target(self)

func _physics_process(delta):
	var direction = Vector2()
	
	if Input.is_action_pressed("move_right_p" + str(playerNumber)):
		direction.x = 1
	if Input.is_action_pressed("move_left_p" + str(playerNumber)):
		direction.x = -1
	
	velocity.x = speed.x * direction.x
	velocity.y += gravity
	
	if (Input.is_action_pressed("move_down_p" + str(playerNumber)) and 
		Input.is_action_just_pressed("jump_p" + str(playerNumber)) and 
		is_on_floor()):
			var PlatformBelow = $FloorRaycast.get_collider()
			if PlatformBelow != null:
				if PlatformBelow.is_in_group("DroppablePlatform"):
					PlatformBelow.IgnorePlayer(playerNumber)
			StateLabel.text = "Drop"
	
	elif Input.is_action_just_pressed("jump_p" + str(playerNumber)) and is_on_floor():
		StateLabel.text = "Jump"
		velocity.y = -speed.y
	elif Input.is_action_just_pressed("attack1_p" + str(playerNumber)):
		$AnimationPlayer.play("Attack")
	
	elif Input.is_action_just_pressed("attack2_p" + str(playerNumber)):
		var b = Bullet.instance()
		b.SetData(playerNumber, facing)
		b.transform = $AttackPoint.global_transform
		owner.add_child(b)
	
	elif Input.is_action_just_pressed("attack3_p" + str(playerNumber)):
		pass
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.5)
	
	if direction.x < 0.5 and direction.x > -0.5:
		MoveLabel.text = "Idle"
		animatedSprite.playing = false
		animatedSprite.animation = "Idle" + str(playerNumber)
	else:
		MoveLabel.text = "Run"
		animatedSprite.playing = true
		animatedSprite.animation = "Run" + str(playerNumber)
	
	if direction.x > 0:
		$AnimatedSprite.scale.x = 0.25
		$MeeleeArea/CollisionShape2D.position.x = 55
		$AttackPoint.position.x = 110
		facing = 1
	elif direction.x < 0:
		$AnimatedSprite.scale.x = -0.25
		$MeeleeArea/CollisionShape2D.position.x = -55
		$AttackPoint.position.x = -110
		facing = -1
	
	if velocity.y > 100 && not is_on_floor():
		animatedSprite.animation = "Falling" + str(playerNumber)
		animatedSprite.playing = true
	elif velocity.y < -100 && not is_on_floor():
		animatedSprite.animation = "Jump" + str(playerNumber)
		animatedSprite.playing = true

func TakeDamage(damage):
	if playerNumber == 1:
		LevelState.P1Health -= damage
		$StateLabel.text = "Health: " + str(LevelState.P1Health)
		$"../healthBars".SetP1Health(LevelState.P1Health)
		if LevelState.P1Health < 0:
			LevelState.PlayerDied(playerNumber)
	elif playerNumber == 2:
		LevelState.P2Health -= damage
		$StateLabel.text = "Health: " + str(LevelState.P2Health)
		$"../healthBars".SetP2Health(LevelState.P2Health)
		if LevelState.P2Health < 0:
			LevelState.PlayerDied(playerNumber)
	
	print(LevelState.P1Health)
	print(LevelState.P2Health)

func _on_MeeleeArea_body_entered(body):
	if "Player" in body.name:
		if body.playerNumber == playerNumber:
			return
		
		body.TakeDamage(10)
