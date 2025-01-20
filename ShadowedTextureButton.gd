extends TextureButton
class_name ShadowedTextureButton

var hovered = false
onready var zero_position = rect_position

func _ready():
	connect("mouse_entered", self, "_on_button_mouse_entered")
	connect("mouse_exited", self, "_on_button_mouse_exited")

func _on_button_mouse_entered():
	hovered = true
	$ShadowZindex.hide()
	rect_position = zero_position + Vector2($ShadowZindex/Shadow.rect_position.x, $ShadowZindex/Shadow.rect_position.y)

func _on_button_mouse_exited():
	hovered = false
	$ShadowZindex.show()
	rect_position = zero_position
