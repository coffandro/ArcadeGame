extends Node

var P1Kills
var P2Kills
var P1Health
var P2Health

func Start():
	P1Kills = 0
	P2Kills = 0
	P1Health = 100
	P2Health = 100

func PlayerDied(PlayerID:int):
	print("Player" + str(PlayerID) + " Died!!!")
