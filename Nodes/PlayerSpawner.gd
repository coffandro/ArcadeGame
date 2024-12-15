extends Node2D

export(PackedScene) var PlayerScene
export var playerNumber:int

#func _ready():
#	SpawnPlayer()

func SpawnPlayer():
	var Player = PlayerScene.instance()
	Player.global_position = global_position
	$"../".call_deferred("add_child",Player)
	Player.playerNumber = playerNumber
	Player.name = "Player" + str(playerNumber)
