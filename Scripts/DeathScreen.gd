extends ColorRect

onready var MusicPlayer = get_node("/root/MusicPlayer")
var backtrack = preload("res://Sound/MenuMusic/Chiptune Vol2 Lighthearted Chill Main.wav")

func _ready():
	hide()

func PlayerWon(PlayerNumber, playerTexture):
	show()
	MusicPlayer.stream = backtrack
	MusicPlayer.play(15)
	$VBoxContainer/WonLabel.text = "Player %s Won!" % PlayerNumber
	$VBoxContainer/RestartButton.grab_focus()
	$PlayerPreview.texture = playerTexture

func _on_RestartButton_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
