tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeRGBAblur9sample

func _init() -> void:
	set_input_port_default_value(2, -1.0)
	set_input_port_default_value(3, 0.5)

func _get_name() -> String:
	return "BlurBasic"

func _get_category() -> String:
	return "RGBA"

func _get_subcategory():
	return "Blur"

func _get_description() -> String:
	return """Basic 8-directional blur with 9 samples
Note: negative lod => detect lod automatically"""

func _get_return_icon_type() -> int:
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_input_port_count() -> int:
	return 4

func _get_input_port_name(port: int):
	match port:
		0:
			return "sampler2D"
		1:
			return "uv"
		2:
			return "lod"
		3:
			return "radius"

func _get_input_port_type(port: int):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SAMPLER
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR

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
	var code : String = preload("blur9sample.gdshader").code
	code = code.replace("shader_type canvas_item;\n", "").replace("shader_type canvas_item;\r\n", "")
	return code

func _get_code(input_vars: Array, output_vars: Array, mode: int, type: int) -> String:
	var texture = "TEXTURE"
	var uv = "UV"
	
	if input_vars[0]:
		texture = input_vars[0]
	if input_vars[1]:
		uv = input_vars[1]
	
	return """vec4 %s%s = _blur9sampleFunc(%s, %s.xy, %s, %s);
%s = %s%s.rgb;
%s = %s%s.a;""" % [
output_vars[0], output_vars[1], texture, uv, input_vars[2], input_vars[3],
output_vars[0], output_vars[0], output_vars[1],
output_vars[1], output_vars[0], output_vars[1]]
