extends KinematicBody2D

export(PackedScene) var Bullet
onready var animatedSprite = $AnimatedSprite
onready var attackPoint = $AttackPoint
onready var attackCooldown = $AttackCooldown
onready var LevelState = get_node("/root/LevelState")

export var speed := Vector2(400.0, 500.0)
export var gravity := 35
var velocity: = Vector2.ZERO

export var playerNumber: int = 1

var on_ladder = false
var facing = 1

var isAttacking = false

var Actions = {
	"Jump" : "jump_p",
	"Left" : "move_left_p",
	"Right" : "move_right_p",
	"Up" : "move_up_p",
	"Down" : "move_down_p",
	"Attack1": "attack1_p",
	"Attack2": "attack2_p",
	"Attack3": "attack3_p"
}
var Anims = {
	"Run": "Run",
	"Shoot": "Shoot",
	"Idle": "Idle",
	"Meelee": "Meelee",
	"Jump": "Jump",
	"Falling": "Falling"
}

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
	
	for i in Actions.keys():
		Actions[i] = Actions[i] + str(playerNumber)
	for i in Anims.keys():
		Anims[i] = Anims[i] + str(playerNumber)

func _physics_process(delta):
	if not isAttacking:
		HandleGravity()
		if on_ladder:
			if Input.is_action_pressed(Actions["Up"]):
				velocity.y = -speed.x * 2
			elif Input.is_action_pressed(Actions["Down"]):
				velocity.y = speed.x * 2
			#else:
			#	velocity.y = 0
		else:
			#Dropping through platforms
			if Input.is_action_pressed(Actions["Down"]) and Input.is_action_pressed(Actions["Jump"]) and is_on_floor():
					var PlatformBelow = $FloorRaycast.get_collider()
					if PlatformBelow != null:
						if PlatformBelow.is_in_group("DroppablePlatform"):
							PlatformBelow.IgnorePlayer(playerNumber)
			# Jumping
			elif Input.is_action_just_pressed(Actions["Jump"]) and is_on_floor():
				velocity.y = -speed.y
		
		var direction = Input.get_axis(Actions["Left"], Actions["Right"])
		
		velocity.x = speed.x * direction
		
		if direction != 0:
			animatedSprite.scale.x = 0.25 * direction
			$MeeleeArea/CollisionShape2D.position.x = 55 * direction
			attackPoint.position.x = 110 * direction
			facing = direction
			animatedSprite.play(Anims["Run"])
		else:
			animatedSprite.play(Anims["Idle"])
		
		velocity = move_and_slide(velocity, Vector2.UP)
		velocity.x = lerp(velocity.x,0,0.5)
		
		if velocity.y > 10 && not is_on_floor():
			animatedSprite.play(Anims["Falling"])
		elif velocity.y < -10 && not is_on_floor():
			animatedSprite.play(Anims["Jump"])
	
	# Handle attack
	if Input.is_action_just_pressed(Actions["Attack1"]) and attackCooldown.is_stopped():
		$AnimationPlayer.play("Attack1")
		animatedSprite.play(Anims["Meelee"])
		isAttacking = true
		attackCooldown.start()
	
	if Input.is_action_just_pressed(Actions["Attack2"]) and attackCooldown.is_stopped():
		# Create bullet and set data
		var b = Bullet.instance()
		b.SetData(playerNumber, facing)
		b.transform = attackPoint.global_transform
		owner.add_child(b)
		# Disable collision via animationPlayer
		$AnimationPlayer.play("Attack2")
		# Set logic for delays
		isAttacking = true
		attackCooldown.start()
		# Play animation
		animatedSprite.play(Anims["Shoot"])
	
	if Input.is_action_just_pressed(Actions["Attack3"]):
		print("Attack3")

func HandleGravity():
	if on_ladder and Input.is_action_pressed(Actions["Up"]):
		return
	if on_ladder and Input.is_action_pressed(Actions["Down"]):
		return
	
	if not is_on_floor():
		velocity.y += gravity

func TakeDamage(damage):
	if playerNumber == 1:
		LevelState.P1Health -= damage
		$"../healthBars".SetP1Health(LevelState.P1Health)
		if LevelState.P1Health < 0:
			LevelState.PlayerDied(playerNumber)
	elif playerNumber == 2:
		LevelState.P2Health -= damage
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


func _on_AnimatedSprite_animation_finished():
	if isAttacking:
		isAttacking = false
		animatedSprite.play(Anims["Idle"])

func _on_BodyArea_body_entered(body):
	if body.is_in_group("Ladder"):
		on_ladder = true
		print(on_ladder)

func _on_BodyArea_body_exited(body):
	if body.is_in_group("Ladder"):
		on_ladder = false
		print(on_ladder)
