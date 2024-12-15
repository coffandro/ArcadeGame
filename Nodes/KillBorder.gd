extends Area2D

#onready var LevelState = get_node("/root/LevelState")

func _on_BottomBorder_body_entered(body):
	if "Player" in body.name:
		$"../".PlayerDied(body.playerNumber)
