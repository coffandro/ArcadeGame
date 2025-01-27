extends Node

#onready var LevelState = get_node("/root/LevelState")
#onready var manual = get_node("/root/Manual")

var Backtrack = preload("res://Sound/MenuMusic/Chiptune Vol2 Lighthearted Chill Main.wav")

func _ready():
	if OS.has_feature("android") || OS.has_feature("mobile") || OS.has_feature("web_android") || OS.has_feature("web_ios"):
		$UI.hide()
		$MobilePopup.popup_centered()

	$"../MusicPlayer".stream = Backtrack
	$"../MusicPlayer".play()
	#manual.rootScene = self

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")

func _on_QuitButton_pressed():
	if OS.has_feature("web"):
		JavaScript.eval("window.history.back();")
	else:
		get_tree().quit()

func _on_GuideButton_pressed() -> void:
	# $UI.set_process_input(false)
	$UI.hide()
	# $Background.hide()
	# $Leaves.hide()
	$Camera.current = false
	#manual.reveal(true)

func ConcealManual():
	$UI.show()
	# $Background.show()
	# $Leaves.show()
	$Camera.current = true


func _on_SelectionTimer_timeout() -> void:
	$UI/VBoxContainer/PlayButton.grab_focus()
	$UI/VBoxContainer/PlayButton.grab_click_focus()
	$UI/VBoxContainer/PlayButton.select()
