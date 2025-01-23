extends ColorRect

onready var MusicPlayer = get_node("/root/MusicPlayer")
#onready var manual = get_node("/root/Manual")
var backtrack = preload("res://Sound/MenuMusic/Chiptune Vol2 Lighthearted Chill Main.wav")

func _ready():
	hide()
	#manual.rootScene = self

func PlayerWon(PlayerNumber, playerTexture):
	show()
	MusicPlayer.stream = backtrack
	MusicPlayer.play(15)
	if PlayerNumber == 1:
		$WonLabel.text = "Stamper Won!"
	elif PlayerNumber == 2:
		$WonLabel.text = "Hamper Won!"
	$VBoxContainer/CenterContainer3/RestartButton.grab_focus()
	$PlayerPreview.texture = playerTexture

func _on_RestartButton_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_GuideButton_pressed() -> void:
	# get_parent().get_parent().hide()
	hide()
	
	#manual.reveal(true)

func ConcealManual():
	# get_parent().get_parent().show()
	show()
