extends Control

export(NodePath) onready var P1Health = get_node(P1Health) as Node
export(NodePath) onready var P1Mini = get_node(P1Mini) as Node
export(NodePath) onready var P2Health = get_node(P2Health) as Node
export(NodePath) onready var P2Mini = get_node(P2Mini) as Node
export(NodePath) onready var TimeLabel = get_node(TimeLabel) as Node
export(NodePath) onready var P1Win = get_node(P1Win) as Node
export(NodePath) onready var P2Win = get_node(P2Win) as Node

var P1Score = 0
var P2Score = 0

func SetP1Health(value:int):
	P1Health.value = value

func SetP2Health(value:int):
	P2Health.value = value

func SetP1Mini(value):
	P1Mini.value = value

func SetP2Mini(value:int):
	P2Mini.value = value

func SetTimeLabel(value:String):
	TimeLabel.text = value

func AddToScore(side):
	if side == 1:
		P1Score += 1
	elif side == 2:
		P2Score += 1
	
	print("P1Score: "+ str(P1Score) +" P2Score: " + str(P2Score))
	
	P1Win.value = P1Score
	P2Win.value = P2Score
	
	
	"""
	if (P1Score == 1 && P2Score == 0):
		P1Win.value = 3
		P2Win.value = 0
	elif (P1Score == 2 && P2Score == 0):
		P1Win.value = 3
		P2Win.value = 0
	elif (P1Score == 3 && P2Score == 0):
		P1Win.value = 3
		P2Win.value = 0
	
	elif (P1Score == 0 && P2Score == 1):
		P1Win.value = 0
		P2Win.value = 3
	elif (P1Score == 0 && P2Score == 2):
		P1Win.value = 0
		P2Win.value = 3
	elif (P1Score == 0 && P2Score == 3):
		P1Win.value = 0
		P2Win.value = 3
	
	elif (P1Score == 1 && P2Score == 1):
		P1Win.value = 1.5
		P2Win.value = 1.5
	
	elif (P1Score == 1 && P2Score == 2):
		P1Win.value = 1
		P2Win.value = 2
	elif (P1Score == 2 && P2Score == 1):
		P1Win.value = 2
		P2Win.value = 1
	"""
