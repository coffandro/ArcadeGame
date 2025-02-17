extends Node2D

export(PackedScene) var PlayerScene
export var player_number:int
var konami_enabled = false

func SpawnPlayer():
	var Player = PlayerScene.instance()
	Player.global_position = global_position
	$"../".call_deferred("add_child", Player)
	Player.player_number = player_number
	Player.add_to_group("Player")
	Player.add_to_group("Player%s" % player_number)
	Player.name = "Player" + str(player_number)
	Player.player_spawner = self

	if konami_enabled:
		Player.call_deferred("enable_Konami")
