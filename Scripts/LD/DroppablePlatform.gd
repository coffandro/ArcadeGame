extends StaticBody2D

var Player1Ignored = false
var Player2Ignored = false

func IgnorePlayer(value:int):
	if value == 1:
		Player1Ignored = true
		set_collision_mask_bit(1, false)
		$Timer1.start()
	elif value == 2:
		Player2Ignored = true
		set_collision_mask_bit(2, false)
		$Timer2.start()

func _on_Timer1_timeout():
	set_collision_mask_bit(1, true)
	Player1Ignored = false

func _on_Timer2_timeout() -> void:
	set_collision_mask_bit(2, true)
	Player2Ignored = false
