extends Node2D

onready var AttackPlayer = $AttackPlayer
onready var ShootPlayer = $ShootPlayer
onready var JumpPlayer = $JumpPlayer
onready var MovePlayer = $MovePlayer

var rng = RandomNumberGenerator.new()

var AttackSounds = [
	preload("res://Sound/Attack/Melee Attack 001.wav"),
	preload("res://Sound/Attack/Melee Attack 002.wav"),
	preload("res://Sound/Attack/Melee Attack 004.wav"),
]

var JumpSounds = [
	preload("res://Sound/Jump/Dash 001.wav"),
	preload("res://Sound/Jump/Dash 009.wav"),
]

var ShootSounds = [
	preload("res://Sound/Shoot/Range Attack 001.wav"),
	preload("res://Sound/Shoot/Range Attack 002.wav"),
	preload("res://Sound/Shoot/Range Attack 003.wav"),
	preload("res://Sound/Shoot/Range Attack 004.wav"),
	preload("res://Sound/Shoot/Range Attack 005.wav"),
	preload("res://Sound/Shoot/Range Attack 006.wav"),
	preload("res://Sound/Shoot/Range Attack 007.wav"),
	preload("res://Sound/Shoot/Range Attack 008.wav"),
]

var MoveSounds1 = [
	preload("res://Sound/Move1/Big Footsteps 001.wav"),
	preload("res://Sound/Move1/Big Footsteps 002.wav"),
	preload("res://Sound/Move1/Big Footsteps 003.wav"),
	preload("res://Sound/Move1/Big Footsteps 004.wav"),
	preload("res://Sound/Move1/Big Footsteps 005.wav"),
	preload("res://Sound/Move1/Big Footsteps 006.wav"),
	preload("res://Sound/Move1/Big Footsteps 007.wav"),
	preload("res://Sound/Move1/Big Footsteps 008.wav"),
	preload("res://Sound/Move1/Big Footsteps 009.wav"),
]

var MoveSounds2 = [
	preload("res://Sound/Move2/Light Footsteps 001.wav"),
	preload("res://Sound/Move2/Light Footsteps 002.wav"),
	preload("res://Sound/Move2/Light Footsteps 003.wav"),
	preload("res://Sound/Move2/Light Footsteps 004.wav"),
	preload("res://Sound/Move2/Light Footsteps 005.wav"),
	preload("res://Sound/Move2/Light Footsteps 006.wav"),
	preload("res://Sound/Move2/Light Footsteps 007.wav"),
	preload("res://Sound/Move2/Light Footsteps 008.wav"),
	preload("res://Sound/Move2/Light Footsteps 009.wav"),
]

var MoveSounds3 = [
	preload("res://Sound/Move3/Mid Footsteps 001.wav"),
	preload("res://Sound/Move3/Mid Footsteps 002.wav"),
	preload("res://Sound/Move3/Mid Footsteps 003.wav"),
	preload("res://Sound/Move3/Mid Footsteps 004.wav"),
	preload("res://Sound/Move3/Mid Footsteps 005.wav"),
	preload("res://Sound/Move3/Mid Footsteps 006.wav"),
	preload("res://Sound/Move3/Mid Footsteps 007.wav"),
	preload("res://Sound/Move3/Mid Footsteps 008.wav"),
	preload("res://Sound/Move3/Mid Footsteps 009.wav"),
]

var CurrentShootSounds = []
var CurrentMoveSounds = []

var player_number

func SetSide(playerSide):
	if playerSide == 1:
		AttackPlayer.bus = "P1Effects"
		ShootPlayer.bus = "P1Effects"
		JumpPlayer.bus = "P1Effects"
		MovePlayer.bus = "P1Effects"
		
		CurrentShootSounds.append(ShootSounds[4])
		CurrentShootSounds.append(ShootSounds[5])
		CurrentShootSounds.append(ShootSounds[6])
		CurrentShootSounds.append(ShootSounds[7])
		
		CurrentMoveSounds = MoveSounds3
	elif playerSide == 2:
		AttackPlayer.bus = "P2Effects"
		ShootPlayer.bus = "P2Effects"
		JumpPlayer.bus = "P2Effects"
		MovePlayer.bus = "P2Effects"
		
		# Sort which shoot sounds are available to p2
		CurrentShootSounds.append(ShootSounds[0])
		CurrentShootSounds.append(ShootSounds[1])
		CurrentShootSounds.append(ShootSounds[2])
		CurrentShootSounds.append(ShootSounds[3])
		
		CurrentMoveSounds = MoveSounds2
	
	player_number = playerSide

func RandomizePitch():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(AttackPlayer.bus), linear2db(rng.randf_range(0.9, 1.1)))

func Attack():
	rng.randomize()
	RandomizePitch()
	
	var sound = rng.randi_range(1,3)
	
	AttackPlayer.stream = AttackSounds[sound-1]
	AttackPlayer.play()

func Shoot():
	rng.randomize()
	RandomizePitch()
	
	var sound = rng.randi_range(1,4)
	
	ShootPlayer.stream = CurrentShootSounds[sound-1]
	ShootPlayer.play()

func Jump():
	rng.randomize()
	RandomizePitch()
	
	var sound = rng.randi_range(1,2)
	
	JumpPlayer.stream = JumpSounds[sound-1]
	JumpPlayer.play()

func Move():
	rng.randomize()
	
	var sound = rng.randi_range(1,9)
	
	if !MovePlayer.playing:
		MovePlayer.stream = CurrentMoveSounds[sound-1]
		MovePlayer.play()
