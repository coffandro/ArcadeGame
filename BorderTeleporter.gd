extends Area2D

enum axisEnum {
	Left,
	Right,
	Up,
	Down
}
export(axisEnum) var axis
export(Vector2) var relativePosition

func _on_BorderTeleporter_body_entered(body):
	if "Player" in body.name:
		if axis == axisEnum.Right:
			body.global_position.x = OS.get_screen_size().x+relativePosition.x
			body.global_position.y += relativePosition.y
		elif axis == axisEnum.Left:
			body.global_position.x = 0+relativePosition.x
			body.global_position.y += relativePosition.y
		if axis == axisEnum.Down:
			body.global_position.y = OS.get_screen_size().y+relativePosition.y
			body.global_position.x += relativePosition.x
		elif axis == axisEnum.Up:
			body.global_position.y = 0+relativePosition.y
			body.global_position.x += relativePosition.x
