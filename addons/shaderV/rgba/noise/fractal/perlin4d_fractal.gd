tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeNoisePerlin4dFractal

func _init() -> void:
	set_input_port_default_value(1, 6)
	set_input_port_default_value(2, Vector3(2, 2, 0))
	set_input_port_default_value(3, 2)
	set_input_port_default_value(4, 0.8)
	set_input_port_default_value(5, 0.5)
	set_input_port_default_value(6, 0.6)
	set_input_port_default_value(7, Vector3(0.5, 0.5, 0))
	set_input_port_default_value(8, 0)
	set_input_port_default_value(9, 0)

func _get_name() -> String:
	return "FractalPerlinNoise4D"

func _get_category() -> String:
	return "RGBA"

func _get_subcategory() -> String:
	return "NoiseFractal"

func _get_description() -> String:
	return "Fractal 4D Perlin Noise"

func _get_return_icon_type() -> int:
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_input_port_count() -> int:
	return 10

func _get_input_port_name(port: int):
	match port:
		0:
			return "uv"
		1:
			return "octaves"
		2:
			return "period"
		3:
			return "lacunarity"
		4:
			return "persistence"
		5:
			return "angle"
		6:
			return "amplitude"
		7:
			return "shift"
		8:
			return "z"
		9:
			return "time"

func _get_input_port_type(port: int):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_VECTOR
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR
		4:
			return VisualShaderNode.PORT_TYPE_SCALAR
		5:
			return VisualShaderNode.PORT_TYPE_SCALAR
		6:
			return VisualShaderNode.PORT_TYPE_SCALAR
		7:
			return VisualShaderNode.PORT_TYPE_VECTOR
		8:
			return VisualShaderNode.PORT_TYPE_SCALAR
		9:
			return VisualShaderNode.PORT_TYPE_SCALAR

func _get_output_port_count() -> int:
	return 1

func _get_output_port_name(port: int) -> String:
	return "result"

func _get_output_port_type(port: int) -> int:
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_global_code(mode: int) -> String:
	var code : String = preload("perlin4d_fractal.gdshader").code
	code = code.replace("shader_type canvas_item;\n", "").replace("shader_type canvas_item;\r\n", "")
	return code

func _get_code(input_vars: Array, output_vars: Array, mode: int, type: int) -> String:
	var uv = "UV"
	
	if input_vars[0]:
		uv = input_vars[0]
	
	return "%s = _perlinNoise4DFBM(%s.xy, int(%s), %s.xy, %s, %s, %s, %s, %s.xy, %s, %s);" % [
	output_vars[0], uv, input_vars[1], input_vars[2], input_vars[3],
	input_vars[4], input_vars[5], input_vars[6], input_vars[7], input_vars[9], input_vars[8]]
