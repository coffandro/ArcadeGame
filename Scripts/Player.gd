extends KinematicBody2D

export(PackedScene) var Bullet
onready var animatedSprite = $AnimatedSprite
onready var attackPoint = $AttackPoint
onready var attackCooldown = $AttackCooldown
onready var healthBars = $"../HealthBars"
onready var speedShader = $AnimatedSprite.get_material()
var playerSpawner = null

export var speed := Vector2(400.0, 500.0)
export var speedBoost := 2
export var gravity := 35
var velocity: = Vector2.ZERO

export var playerNumber: int = 1

var isAttacking = false
var on_ladder = false
var facing = 1

var bullets = 5
var currrentPowerUp = ""
var HealthSetFunction
var MiniSetFunction
var TimeLabelSetFunction

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
	"Falling": "Falling",
	"Ladder": "Ladder"
}

var konami_enabled = false
var konami = []

func _unhandled_input(event: InputEvent) -> void:
	if not konami_enabled:
		if (event.is_action_pressed(Actions["Up"]) || event.is_action_pressed(Actions["Down"]) || event.is_action_pressed(Actions["Left"]) || event.is_action_pressed(Actions["Right"]) || event.is_action_pressed(Actions["Attack1"]) || event.is_action_pressed(Actions["Attack2"]) || event.is_action_pressed(Actions["Jump"])):
			if konami.empty() and event.is_action_pressed(Actions["Up"]):
				konami.append("Up")
			elif konami.size() == 1 and konami[0] == "Up" and event.is_action_pressed(Actions["Up"]):
				konami.append("Up")
			elif konami.size() == 2 and konami[1] == "Up" and event.is_action_pressed(Actions["Down"]):
				konami.append("Down")
			elif konami.size() == 3 and konami[2] == "Down" and event.is_action_pressed(Actions["Down"]):
				konami.append("Down")
			elif konami.size() == 4 and konami[3] == "Down" and event.is_action_pressed(Actions["Left"]):
				konami.append("Left")
			elif konami.size() == 5 and konami[4] == "Left" and event.is_action_pressed(Actions["Right"]):
				konami.append("Right")
			elif konami.size() == 6 and konami[5] == "Right" and event.is_action_pressed(Actions["Left"]):
				konami.append("Left")
			elif konami.size() == 7 and konami[6] == "Left" and event.is_action_pressed(Actions["Right"]):
				konami.append("Right")
			elif konami.size() == 8 and konami[7] == "Right" and event.is_action_pressed(Actions["Attack1"]):
				konami.append("Attack1")
			elif konami.size() == 9 and konami[8] == "Attack1" and event.is_action_pressed(Actions["Attack2"]):
				konami.append("Attack2")
			elif konami.size() == 10 and konami[9] == "Attack2" and event.is_action_pressed(Actions["Jump"]):
				enable_Konami()
			else:
				konami = []

func enable_Konami():
	konami_enabled = true
	print("Did the konami")
	for i in Anims.keys():
		Anims[i] = Anims[i].insert(Anims[i].length()-1,"E")

	if not playerSpawner.konami_enabled:
		if playerNumber == 1:
			playerSpawner.konami_enabled = true
		elif playerNumber == 2:
			playerSpawner.konami_enabled = true

func _ready():
	$Shield.hide()

	if playerNumber == 1:
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(1, true)
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, true)
	elif playerNumber == 2:
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(1, false)
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, false)
	else:
		print("The fuck you doing my duude?, playerNumber > 2")
	
	$AudioManager.SetBus(playerNumber)
	
	for i in Actions.keys():
		Actions[i] = Actions[i] + str(playerNumber)
	for i in Anims.keys():
		Anims[i] = Anims[i] + str(playerNumber)
	
	HealthSetFunction = "SetP1Health" if playerNumber == 1 else "SetP2Health"
	MiniSetFunction = "SetP1Mini" if playerNumber == 1 else "SetP2Mini"

func _physics_process(_delta):
	HandleGravity()
	if not isAttacking:
		if on_ladder:
			if Input.is_action_pressed(Actions["Up"]):
				velocity.y = -speed.x * 2
			elif Input.is_action_pressed(Actions["Down"]):
				velocity.y = speed.x * 2
		
		#Dropping through platforms
		if Input.is_action_pressed(Actions["Down"]) and Input.is_action_pressed(Actions["Jump"]) and is_on_floor():
				var PlatformBelow = $PlatformRaycast.get_collider()
				if PlatformBelow != null:
					if PlatformBelow.is_in_group("DroppablePlatform"):
						PlatformBelow.IgnorePlayer(playerNumber)
		
		# Jumping
		elif Input.is_action_just_pressed(Actions["Jump"]) and is_on_floor():
			velocity.y = -speed.y
			$AudioManager.Jump()
			
		elif !Input.is_action_pressed(Actions["Up"]) and !Input.is_action_pressed(Actions["Jump"]) and velocity.y < 0:
			velocity.y = 0
		
		var direction = Input.get_axis(Actions["Left"], Actions["Right"])
		
		velocity.x = speed.x * direction

		if currrentPowerUp == "Speed":
			velocity.x *= speedBoost
		
		if direction != 0:
			# create variable multipler with the value -1 if direction is less than 0, else it's 1
			var multipler = -1 if direction < 0 else 1
			
			animatedSprite.scale.x = 0.25 * multipler
			attackPoint.position.x = 110 * multipler
			
			if playerNumber == 1:
				$MeeleeArea/CollisionShape2D.position.x = 32 * multipler
			elif playerNumber == 2:
				$MeeleeArea/CollisionShape2D.position.x = 16 * multipler
			
			facing = multipler
			animatedSprite.play(Anims["Run"])
			if is_on_floor():
				$AudioManager.Move()
		elif on_ladder and (velocity.y < -10 || velocity.y > 10):
			if Input.is_action_pressed(Actions["Up"]) || Input.is_action_pressed(Actions["Down"]):
				animatedSprite.play(Anims["Ladder"])
			else:
				animatedSprite.play(Anims["Falling"])
		else:
			animatedSprite.play(Anims["Idle"])
		
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x,0,0.5)
	
	# Set falling or jumping animations
	if not isAttacking:
		if not on_ladder:
			if velocity.y > 200 && not is_on_floor():
				animatedSprite.play(Anims["Falling"])
			elif velocity.y < -10 && not is_on_floor():
				animatedSprite.play(Anims["Jump"])
	
	# Handle attack
	if Input.is_action_just_pressed(Actions["Attack1"]) and attackCooldown.is_stopped():
		MeeleeAttack(true)
	
	if Input.is_action_just_pressed(Actions["Attack2"]) and attackCooldown.is_stopped():
		RangedAttack(true)

func MeeleeAttack(timeout):
	$AnimationPlayer.play("Attack1")
	animatedSprite.play(Anims["Meelee"])
	isAttacking = true
	if timeout:
		attackCooldown.start()
		$AudioManager.Attack()

func RangedAttack(timeout):
	if bullets > 0:
		# Create bullet and set data
		var b = Bullet.instance()
		b.SetData(playerNumber, facing)
		b.transform = attackPoint.global_transform
		$"../".add_child(b)
		# Disable collision via animationPlayer
		# Set logic
		isAttacking = true
		$AudioManager.Shoot()
		if timeout:
			attackCooldown.start()
		# Play animation
		animatedSprite.play(Anims["Shoot"])
		# Handle UI
		bullets -= 1
		healthBars.call(MiniSetFunction, bullets)

func HandleGravity():
	if on_ladder and Input.is_action_pressed(Actions["Up"]):
		return
	if on_ladder and Input.is_action_pressed(Actions["Down"]):
		return
	
	if not is_on_floor():
		velocity.y += gravity

func TakeDamage(damage):
	if currrentPowerUp == "Shield":
		return

	if playerNumber == 1:
		$"../".P1Health -= damage
		healthBars.call(HealthSetFunction, $"../".P1Health)
		if $"../".P1Health <= 0:
			$"../".PlayerDied(playerNumber)
			#queue_free()
	elif playerNumber == 2:
		$"../".P2Health -= damage
		healthBars.call(HealthSetFunction, $"../".P2Health)
		if $"../".P2Health <= 0:
			$"../".PlayerDied(playerNumber)
			#queue_free()

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

func _on_BodyArea_body_exited(body):
	if body.is_in_group("Ladder"):
		on_ladder = false

func apply_power_up(powerup: int):
	match powerup:
		1:
			currrentPowerUp = ""
			bullets = 5
			healthBars.call(MiniSetFunction, bullets)
		2:
			currrentPowerUp = "Speed"
			speedShader.set_shader_param("enabled", true)
			$BoostTimer.start()	
		3:
			currrentPowerUp = "Shield"
			$Shield.show()
			$ShieldTimer.start()

func _on_ShieldTimer_timeout() -> void:
	$Shield.hide()
	currrentPowerUp = ""

func _on_BoostTimer_timeout() -> void:
	currrentPowerUp = ""
	speedShader.set_shader_param("enabled", false)
