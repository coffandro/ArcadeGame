extends TextureButton
class_name ShadowedTextureButton

onready var zero_position = rect_position

func _ready():
	connect("mouse_entered", self, "_on_button_mouse_entered")
	connect("mouse_exited", self, "_on_button_mouse_exited")
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")

func _on_button_mouse_entered():
	grab_focus()
	grab_click_focus()
	select()

func _on_button_mouse_exited():
	unselect()

func _on_focus_entered():
	select()

func _on_focus_exited():
	unselect()

func select():
	$ShadowZindex.hide()
	rect_position = zero_position + Vector2($ShadowZindex/Shadow.rect_position.x, $ShadowZindex/Shadow.rect_position.y)

func unselect():
	$ShadowZindex.show()
	rect_position = zero_position