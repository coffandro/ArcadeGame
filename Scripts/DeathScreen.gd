extends ColorRect

onready var MusicPlayer = get_node("/root/MusicPlayer")
#onready var manual = get_node("/root/Manual")
var backtrack = preload("res://Sound/MenuMusic/Chiptune Vol2 Lighthearted Chill Main.wav")

func _ready():
	hide()
	if not OS.has_feature("QR"):
		$QRButton.hide()
	#manual.rootScene = self

func PlayerWon(PlayerNumber, playerTexture):
	$SelectionTimer.start()
	show()
	MusicPlayer.stream = backtrack
	MusicPlayer.play(15)
	if PlayerNumber == 1:
		$WonLabel.text = "Stamper Won!"
	elif PlayerNumber == 2:
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

func _on_GuideButton_pressed() -> void:
	# get_parent().get_parent().hide()
	hide()
	
	#manual.reveal(true)

func ConcealManual():
	# get_parent().get_parent().show()
	show()
