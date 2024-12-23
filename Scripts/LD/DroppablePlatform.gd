extends StaticBody2D

var LastPlayer

func IgnorePlayer(value:int):
	print(value)
	LastPlayer = value
	set_collision_layer_bit(value, false)
	set_collision_mask_bit(value, false)
	$Timer.start()

func _on_Timer_timeout():
	set_collision_layer_bit(LastPlayer, true)
	set_collision_mask_bit(LastPlayer, true)
	LastPlayer = 0
