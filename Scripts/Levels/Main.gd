extends Node

#onready var LevelState = get_node("/root/LevelState")

func _ready():
	$Control/VBoxContainer/PlayButton.grab_focus()

func _on_Button_pressed():
	#LevelState.Start()
	get_tree().change_scene("res://Levels/Level1.tscn")

