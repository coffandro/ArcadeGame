extends ColorRect

onready var MusicPlayer = get_node("/root/MusicPlayer")
#onready var manual = get_node("/root/Manual")
var backtrack = preload("res://Sound/Music/Death.mp3")

func _ready():
	hide()
	if not OS.has_feature("QR"):
		$QRButton.hide()
	if not OS.has_feature("windows"):
		$QRButton/VBoxContainer/WinLabel.hide()
	#manual.rootScene = self

func PlayerWon(player_number, playerTexture):
	$SelectionTimer.start()
	show()
	MusicPlayer.stream = backtrack
	MusicPlayer.last_stream = backtrack
	MusicPlayer.play(15)
	if player_number == 1:
		$WonLabel.text = "Stamper Won!"
	elif player_number == 2:
		$WonLabel.text = "Hamper Won!"
	$PlayerPreview.texture = playerTexture

func _on_SelectionTimer_timeout() -> void:
	$VBoxContainer/CenterContainer3/RestartButton.grab_focus()
	$VBoxContainer/CenterContainer3/RestartButton.grab_click_focus()
	$VBoxContainer/CenterContainer3/RestartButton.select()

func _on_RestartButton_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")

func _on_QuitButton_pressed():
	if OS.has_feature("web"):
		JavaScript.eval("window.history.back();")
	else:
		get_tree().quit()
