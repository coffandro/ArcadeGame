tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeRGBAshiftHSV

func _init() -> void:
	set_input_port_default_value(1, 0.0)
	set_input_port_default_value(2, 1.0)
	set_input_port_default_value(3, 1.0)

func _get_name() -> String:
	return "ShiftHSV"

func _get_category() -> String:
	return "RGBA"

#func _get_subcategory():
#	return ""

func _get_description() -> String:
	return """Changes hue, saturation and value of input color.
[hue] will be added to [color] hue, so [col].hue = [color].hue + [hue].
[color] saturation and value will be multiplied by [sat] and [value], so [col].saturation(OR)value = [color].saturation(OR)value +* [sat](OR)[value]"""

func _get_return_icon_type() -> int:
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_input_port_count() -> int:
	return 4

func _get_input_port_name(port: int):
	match port:
		0:
			return "color"
		1:
			return "hue"
		2:
			return "sat"
		3:
			return "value"

func _get_input_port_type(port: int):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR

func _get_output_port_count() -> int:
	return 1

func _get_output_port_name(port: int) -> String:
	return "col"

func _get_output_port_type(port: int) -> int:
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_global_code(mode: int) -> String:
	var code : String = preload("shiftHSV.gdshader").code
	code = code.replace("shader_type canvas_item;\n", "").replace("shader_type canvas_item;\r\n", "")
	return code

func _get_code(input_vars: Array, output_vars: Array, mode: int, type: int) -> String:
	return "%s = _hsvChangeHSVChangeFunc(%s, %s, %s, %s);" % [
output_vars[0], input_vars[0], input_vars[1], input_vars[2], input_vars[3]]
