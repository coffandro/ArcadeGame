extends Node

onready var audioPlayer0 = $AudioStreamPlayer0
onready var audioPlayer1 = $AudioStreamPlayer1
onready var audioPlayer2 = $AudioStreamPlayer2
onready var audioPlayer3 = $AudioStreamPlayer3
onready var audioPlayer4 = $AudioStreamPlayer4

var soundFiles = []
var audioPlayers = []

func Start():
	audioPlayers.append(audioPlayer0)
	audioPlayers.append(audioPlayer1)
	audioPlayers.append(audioPlayer2)
	audioPlayers.append(audioPlayer3)
	audioPlayers.append(audioPlayer4)

func Play(value:int):
	for i in audioPlayers:
		if not i.playing:
			i.stream = soundFiles[value]
			i.Play()
