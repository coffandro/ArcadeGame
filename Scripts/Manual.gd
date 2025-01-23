extends Node

onready var animationPlayer = $AnimationPlayer
var rootScene

func _ready() -> void:
	conceal()

func reveal(UseCamera: bool = false):
	$Node2D.show()
	$Node2D/ViewportContainer/Viewport/World.show()
	$Node2D/ViewportContainer/Viewport/UI.show()
	$Node2D/ViewportContainer/Viewport/World/Camera.current = UseCamera

func conceal():
	$Node2D.hide()
	$Node2D/ViewportContainer/Viewport/World.hide()
	$Node2D/ViewportContainer/Viewport/UI.hide()
	$Node2D/ViewportContainer/Viewport/World/Camera.current = false
	if rootScene != null:
		rootScene.ConcealManual()

func _on_AnimationPlayer_animation_finished(anim_name:String) -> void:
	if anim_name != "RESET":
		animationPlayer.play("RESET")

func _on_ExitButton_pressed() -> void:
	conceal()

func _on_RightButton_pressed() -> void:
	animationPlayer.play("TurnLeft")

func _on_LeftButton_pressed() -> void:
	animationPlayer.play("TurnRight")
