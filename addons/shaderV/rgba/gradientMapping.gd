tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeRGBAgradientMapping

func _init() -> void:
	set_input_port_default_value(1, 1.0)
	set_input_port_default_value(2, 0.0)
	set_input_port_default_value(3, false)

func _get_name() -> String:
	return "GradientMapping"

func _get_category() -> String:
	return "RGBA"

#func _get_subcategory():
#	return ""

func _get_description() -> String:
	return """Remaps colors based on average color value using [gradient].
[gradientOffset] allows to do color cycling if set TIME to [gradientOffset] and 'true' to [cycleColor]"""

func _get_return_icon_type() -> int:
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_input_port_count() -> int:
	return 5

func _get_input_port_name(port: int):
	match port:
		0:
			return "color"
		1:
			return "alpha"
		2:
			return "gradientOffset"
		3:
			return "cycleColor"
		4:
			return "gradient"

func _get_input_port_type(port: int):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR
		3:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		4:
			return VisualShaderNode.PORT_TYPE_SAMPLER

func _get_output_port_count() -> int:
	return 2

func _get_output_port_name(port: int):
	match port:
		0:
			return "col"
		1:
			return "alpha"

func _get_output_port_type(port: int):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR

func _get_global_code(mode: int) -> String:
	var code : String = preload("gradientMapping.gdshader").code
	code = code.replace("shader_type canvas_item;\n", "").replace("shader_type canvas_item;\r\n", "")
	return code

func _get_code(input_vars: Array, output_vars: Array, mode: int, type: int) -> String:
	return """vec4 %s%s = _gradientMappingFunc(%s, %s, %s, %s);
%s = %s%s.rgb;
%s = %s%s.a * %s;""" % [
output_vars[0], output_vars[1], input_vars[0], input_vars[2], input_vars[4], input_vars[3],
output_vars[0], output_vars[0], output_vars[1],
output_vars[1], output_vars[0], output_vars[1], input_vars[1]]
