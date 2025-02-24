extends Node

var Backtrack = preload("res://Sound/MenuMusic/Chiptune Vol2 Lighthearted Chill Main.wav")
var StartSound = preload("res://Sound/Start.mp3")

onready var UI = $UI
onready var mobile_popup = $MobilePopup
onready var music_player = get_node("/root/MusicPlayer")
onready var play_button = $UI/VBoxContainer/CenterContainer/PlayButton

func _ready():
	if OS.has_feature("android") || OS.has_feature("mobile") || OS.has_feature("web_android") || OS.has_feature("web_ios"):
		UI.hide()
		mobile_popup.popup_centered()
		return

	music_player.stream = Backtrack
	music_player.last_stream = Backtrack
	music_player.play()

func _on_PlayButton_pressed():
	$StartSoundPlayer.play()

func _on_StartSoundPlayer_finished():
	get_tree().change_scene("res://Levels/Level1.tscn")

func _on_QuitButton_pressed():
	if OS.has_feature("web"):
		JavaScript.eval("window.history.back();")
	else:
		get_tree().quit()

func _on_SelectionTimer_timeout() -> void:
	play_button.grab_focus()
	play_button.grab_click_focus()
	play_button.select()
