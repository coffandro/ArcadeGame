extends Node2D

var P1Score
var P2Score
var P1Health
var P2Health
var roundsPlayed = 0

var random = RandomNumberGenerator.new()

var Songs = [
	preload("res://Sound/Level1Music/Chiptune Chilled Fun Intensity 1.wav"),
	preload("res://Sound/Level1Music/Chiptune Chilled Fun Intensity 2.wav"),
]

onready var PelletSpawners = [
	$PowerPellet,
	$PowerPellet2,
	$PowerPellet3,
	$PowerPellet4,
	$PowerPellet5
]

var CurrentPelletSpawners = []

func _ready():
	P1Score = 0
	P2Score = 0

	var index = 0
	for i in PelletSpawners:
		CurrentPelletSpawners.append(i)
		i.connect("picked_up", self, "add_to_current_pelletspawners")
		i.id = index
		index += 1
	
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
	
	if roundsPlayed > 2:
		roundsPlayed = 0
	
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
	

	if P1Score > 1 || P2Score > 1: 
		if P1Score > P2Score:
			print("Player 1 won")
			var player1texture
			for child in get_children():
				if child.is_in_group("Player1"):
					player1texture = child.animatedSprite.frames.get_frame("Meelee1", 1)

			$CanvasLayer/DeathScreen.PlayerWon(1, player1texture)
			for child in get_children():
				if child.is_in_group("Player"):
					child.queue_free()

		if P2Score > P1Score:
			print("Player 2 won")
			var player2texture
			for child in get_children():
				if child.is_in_group("Player2"):
					player2texture = child.animatedSprite.frames.get_frame("Meelee2", 1)

			$CanvasLayer/DeathScreen.PlayerWon(2, player2texture)
			for child in get_children():
				if child.is_in_group("Player"):
					child.queue_free()

	else:
		StartRound()

func add_to_current_pelletspawners(spawner):
	CurrentPelletSpawners.append(spawner)


func _on_PelletSpawn_timeout() -> void:
	if CurrentPelletSpawners.size() > 0:
		random.randomize()
		var PelletSpawner = random.randi_range(0, CurrentPelletSpawners.size()-1)
		random.randomize()
		CurrentPelletSpawners[PelletSpawner].SpawnPellet(random.randi_range(1, PelletSpawners[PelletSpawner].powerUps.size()))
		CurrentPelletSpawners.remove(PelletSpawner)
