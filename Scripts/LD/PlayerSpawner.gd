extends Node2D

export(PackedScene) var PlayerScene
export var playerNumber:int
var konami_enabled = false

func SpawnPlayer():
	var Player = PlayerScene.instance()
	Player.global_position = global_position
	$"../".call_deferred("add_child",Player)
	Player.playerNumber = playerNumber
	Player.add_to_group("Player")
	Player.add_to_group("Player%s" % playerNumber)
	Player.name = "Player" + str(playerNumber)
	Player.playerSpawner = self

	if konami_enabled:
		Player.call_deferred("enable_Konami")
