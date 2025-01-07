extends Node2D

var P1Score
var P2Score
var P1Health
var P2Health
var roundsPlayed = 0

var Songs = [
	preload("res://Sound/Level1Music/Chiptune Chilled Fun Intensity 1.wav"),
	preload("res://Sound/Level1Music/Chiptune Chilled Fun Intensity 2.wav"),
	preload("res://Sound/Level1Music/Chiptune Chilled Fun main.wav"),
]

func _ready():
	P1Score = 0
	P2Score = 0
	
	StartRound()

func StartRound():
	P1Health = 100
	P2Health = 100
	$HealthBars.P1Health.value = 100
	$HealthBars.P2Health.value = 100
	$HealthBars.P1Mini.value = 5
	$HealthBars.P2Mini.value = 5
	
	for i in get_children():
		if "Player" in i.name and not "PlayerSpawner" in i.name:
			i.queue_free()
	
	$PlayerSpawner1.call_deferred("SpawnPlayer")
	$PlayerSpawner2.call_deferred("SpawnPlayer")
	
	$"../MusicPlayer".stream = Songs[roundsPlayed]
	$"../MusicPlayer".play()

func PlayerDied(PlayerID:int):
	roundsPlayed += 1
	
	print("Player" + str(PlayerID) + " Died!!!")
	
	if PlayerID == 1:
		$HealthBars.AddToScore(2)
		P2Score += 1
	elif PlayerID == 2:
		$HealthBars.AddToScore(1)
		P1Score += 1
	
	if roundsPlayed == 3:
		if P1Score > P2Score:
			print("Player 1 won")
			$DeathScreen.PlayerWon(1)
		if P2Score > P1Score:
			print("Player 2 won")
			$DeathScreen.PlayerWon(2)
	else:
		StartRound()
