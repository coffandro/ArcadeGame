extends HBoxContainer

export(NodePath) onready var P1Health = get_node(P1Health) as Node
export(NodePath) onready var P1Mini = get_node(P1Mini) as Node
export(NodePath) onready var P2Health = get_node(P2Health) as Node
export(NodePath) onready var P2Mini = get_node(P2Mini) as Node

func SetP1Health(value:int):
	P1Health.value = value

func SetP2Health(value:int):
	P2Health.value = value

func SetP1Mini(value:int):
	P1Mini.value = value

func SetP2Min(value:int):
	P2Mini.value = value
