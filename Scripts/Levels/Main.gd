extends Node

#onready var LevelState = get_node("/root/LevelState")

var Backtrack = preload("res://Sound/MenuMusic/Chiptune Vol2 Lighthearted Chill Main.wav")

func _ready():
	$Control/VBoxContainer/PlayButton.grab_focus()
	$"../MusicPlayer".stream = Backtrack
	$"../MusicPlayer".play()

func _on_Button_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
