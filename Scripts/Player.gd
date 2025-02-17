extends KinematicBody2D

# Export a bullet scene link
export(PackedScene) var Bullet
# Prepare all the subnodes we need
onready var animated_sprite = $AnimatedSprite
onready var attack_point = $AttackPoint
onready var attack_cooldown = $AttackCooldown
onready var health_bars = $"../HealthBars"
onready var speed_shader = $AnimatedSprite.get_material()
onready var animation_player = $AnimationPlayer
onready var shield = $Shield
onready var audio_manager = $AudioManager
onready var parent = get_parent()
onready var coyote_timer = $CoyoteTimer
# Player spawner for konami code checking in rounds after initialization
var player_spawner = null

# Export player speed x, player speed y, the boost to be applied upon speedup and the gravity
export var speed := Vector2(400.0, 500.0)
export var speed_boost := 2
export var gravity := 35
# velocity variable
var velocity: = Vector2.ZERO

# Player number. decides most stuff regarding who the player is hitting and such
export var player_number: int = 1

# State variables 
var is_attacking = false
var on_ladder = false
var facing = 1

# Bullets and current power up, for checking in functions
var bullets = 5
var current_power_up = ""
var jumping = false

export var coyote_frames = 20  # How many in-air frames to allow jumping
var coyote = false  # Track whether we're in coyote time or not
var last_floor = false  # Last frame's on-floor state

# Held functions, will be used to decide which one's to use during start of game
var HealthSetFunction
var MiniSetFunction

# Archived actions and anims, for assigning later on
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

# Konami variables
var konami_enabled = false
var konami = []

# Unhandled input function, mostly just to check if hte konami code has been done
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

# Function to enable Konami code
func enable_Konami():
	konami_enabled = true
	print("Did the konami")

	# Insert konami code E's to animations
	for i in Anims.keys():
		Anims[i] = Anims[i].insert(Anims[i].length()-1,"E")

	# Assing player spawner konami boolean, for applying to player during ready
	player_spawner.konami_enabled = true

# Ready function, is run when player is loaded
func _ready():
	# Hide node's for future showing
	shield.hide()

	# Set collisions dependant upon if player is left or right
	set_collision_layer_bit(0, false)
	if player_number == 1:
		set_collision_layer_bit(1, true)
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, true)
	elif player_number == 2:
		set_collision_layer_bit(1, false)
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, false)
	
	# Set side, so that we audio manager may use the correct effects
	audio_manager.SetSide(player_number)
	
	# Apply player number to actions and animations
	for i in Actions.keys():
		Actions[i] = Actions[i] + str(player_number)
	for i in Anims.keys():
		Anims[i] = Anims[i] + str(player_number)

	coyote_timer.wait_time = coyote_frames / 60.0
	
	# Assign functions dependent on player number
	HealthSetFunction = "SetP1Health" if player_number == 1 else "SetP2Health"
	MiniSetFunction = "SetP1Mini" if player_number == 1 else "SetP2Mini"

# Handle the gravity of the player
func HandleGravity():
	# Don't handle the gravity is is going up or down
	if on_ladder and Input.is_action_pressed(Actions["Up"]):
		return
	if on_ladder and Input.is_action_pressed(Actions["Down"]):
		return
	
	# Apply gravity to velocity in case the player is not on floor
	if not is_on_floor():
		velocity.y += gravity

# Physics process, runs every physics frame
func _physics_process(_delta):
	# Run the handle gravity function
	HandleGravity()
	
	# Only do this part if the player is not currently attacking
	if not is_attacking:
		# Make velocity move up and down on Y axis timed by 2 if on ladder
		if on_ladder:
			if Input.is_action_pressed(Actions["Up"]):
				velocity.y = -speed.x * 2
			elif Input.is_action_pressed(Actions["Down"]):
				velocity.y = speed.x * 2
		
		#Dropping through platforms, only if on floor, the floor is a droppable platform and down plus jump is pressed 
		if Input.is_action_pressed(Actions["Down"]) and Input.is_action_pressed(Actions["Jump"]) and is_on_floor():
			var PlatformBelow = $PlatformRaycast.get_collider()
			if PlatformBelow != null:
				if PlatformBelow.is_in_group("DroppablePlatform"):
					PlatformBelow.IgnorePlayer(player_number)
		
		# Jumping if currently on floor
		elif Input.is_action_just_pressed(Actions["Jump"]) and (is_on_floor() or coyote):
			velocity.y = -speed.y
			audio_manager.Jump()
			jumping = true
			coyote = false
		
		# I... don't know, think this normalizes the velocity when no longer falling?
		elif !Input.is_action_pressed(Actions["Up"]) and !Input.is_action_pressed(Actions["Jump"]) and velocity.y < 0:
			velocity.y = 0
		
		# Get direction on x axis
		var direction = Input.get_axis(Actions["Left"], Actions["Right"])
		
		# Apply direction times speed to velocity on x
		velocity.x = speed.x * direction

		# Apply speed boosy to x velocity if Speed power up is applied
		if current_power_up == "Speed":
			velocity.x *= speed_boost
		
		# if moving in any direction on x axis
		if direction != 0:
			# create variable multipler with the value -1 if direction is less than 0, else it's 1
			var multipler = -1 if direction < 0 else 1
			
			# scale animated_sprite with direction
			animated_sprite.scale.x = 0.25 * multipler
			
			# Apply meelee area position dependent on player number, to allow the bunny to have longer reach
			if player_number == 1:
				$MeeleeArea/CollisionShape2D.position.x = 32 * multipler
			elif player_number == 2:
				$MeeleeArea/CollisionShape2D.position.x = 16 * multipler
			
			# make facing into multipler
			facing = multipler

			# apply run animation, since actively moving
			animated_sprite.play(Anims["Run"])
			
			# Apply the move audio if on floor
			if is_on_floor():
				audio_manager.Move()
		# checks if on on ladder and moving instead if not moving on x
		elif on_ladder and (velocity.y < -10 || velocity.y > 10):
			# apply the up animation if actively going up or down
			if Input.is_action_pressed(Actions["Up"]) || Input.is_action_pressed(Actions["Down"]):
				animated_sprite.play(Anims["Ladder"])
			# otherwise apply falling animations
			else:
				animated_sprite.play(Anims["Falling"])
		# if no other animations apply, use idle
		else:
			animated_sprite.play(Anims["Idle"])

	# Apply velocity to player
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x,0,0.5)

	if is_on_floor() and jumping:
		jumping = false
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		coyote_timer.start()

	# change last_floor variable for checking next frame, coyote time
	last_floor = is_on_floor()
	
	# Set falling or jumping animations, but only if not attacking or on a ladder
	if not is_attacking and not on_ladder:
		if velocity.y > 200 && not is_on_floor():
			animated_sprite.play(Anims["Falling"])
		elif velocity.y < -10 && not is_on_floor():
			animated_sprite.play(Anims["Jump"])
	
	# Meelee attack
	if Input.is_action_just_pressed(Actions["Attack1"]) and attack_cooldown.is_stopped():
		MeeleeAttack()
	
	# Ranged attack
	if Input.is_action_just_pressed(Actions["Attack2"]) and attack_cooldown.is_stopped():
		RangedAttack()

# Meelee attack function
func MeeleeAttack():
	animation_player.play("Attack1")
	animated_sprite.play(Anims["Meelee"])
	is_attacking = true
	attack_cooldown.start()
	audio_manager.Attack()

# Ranged attack function
func RangedAttack():
	if bullets > 0:
		# Create bullet and set data
		var b = Bullet.instance()
		b.SetData(player_number, facing)
		# set the position to the current attack point position
		b.transform = attack_point.global_transform
		# add the child to the main node
		parent.add_child(b)
		# Set logic for shooting and starting a cooldown
		is_attacking = true
		audio_manager.Shoot()
		attack_cooldown.start()
		# Play animation
		animated_sprite.play(Anims["Shoot"])
		# Handle UI
		bullets -= 1
		health_bars.call(MiniSetFunction, bullets)

func TakeDamage(damage):
	# don't apply damage if current powerup is shield
	if current_power_up == "Shield":
		return

	# Apply damage acording to player number, update ui and kill if dead
	if player_number == 1:
		parent.P1Health -= damage
		health_bars.call(HealthSetFunction, parent.P1Health)
		if parent.P1Health <= 0:
			parent.PlayerDied(player_number)
	elif player_number == 2:
		parent.P2Health -= damage
		health_bars.call(HealthSetFunction, parent.P2Health)
		if parent.P2Health <= 0:
			parent.PlayerDied(player_number)

# Do damage handling in case the body which has entered this is Player
func _on_MeeleeArea_body_entered(body):
	if "Player" in body.name:
		if body.player_number == player_number:
			return
		
		body.TakeDamage(10)

# Set logic and return to normal animation if the animation stops and the player is attacked
func _on_AnimatedSprite_animation_finished():
	if is_attacking:
		is_attacking = false
		animated_sprite.play(Anims["Idle"])

# make on_ladder true or false when player enters and exits it
func _on_BodyArea_body_entered(body):
	if body.is_in_group("Ladder"):
		on_ladder = true
func _on_BodyArea_body_exited(body):
	if body.is_in_group("Ladder"):
		on_ladder = false

# apply power up
func apply_power_up(powerup: int):
	match powerup:
		1:
			# Make bullets 5, if powerup is bullets
			current_power_up = ""
			bullets = 5
			health_bars.call(MiniSetFunction, bullets)
		2:
			# Set power up to Speed if it is so
			current_power_up = "Speed"
			speed_shader.set_shader_param("enabled", true)
			$BoostTimer.start()	
		3:
			# set power up to shield if it is so
			current_power_up = "Shield"
			shield.show()
			$ShieldTimer.start()

func _on_CoyoteTimer_timeout():
	coyote = false

# Timers to disable shield and boost power ups if 
func _on_ShieldTimer_timeout() -> void:
	current_power_up = ""
	shield.hide()
func _on_BoostTimer_timeout() -> void:
	current_power_up = ""
	speed_shader.set_shader_param("enabled", false)
