tool
extends EditorPlugin


func _enter_tree():
	pass

func build() -> bool:

	print("I run before build")
	return true # fail build by return false

func _exit_tree():
	pass