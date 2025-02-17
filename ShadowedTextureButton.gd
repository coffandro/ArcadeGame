extends TextureButton
class_name ShadowedTextureButton

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
	rect_scale = Vector2.ONE * 1.25
	rect_pivot_offset = rect_size/2

func unselect():
	rect_scale = Vector2.ONE
	rect_pivot_offset = rect_size/2
