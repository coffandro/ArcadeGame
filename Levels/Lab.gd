extends Spatial

func _ready():
	$AnimationPlayer.play("Stage1")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Stage1":
		$Square1.rotation_degrees = Vector3(0,0,0)
		$Square2.rotation_degrees = Vector3(0,0,0)
		$AnimationPlayer.play("Stage1")
