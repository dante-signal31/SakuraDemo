shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 water_color: source_color;
uniform float water_color_intensity: hint_range(0.0, 1.0, 0.01) = 0.7;
uniform float mirrored_colors_intensity = 1.4;
uniform float reflection_limit: hint_range(0.0, 1.0, 0.01);

vec2 get_mirrored_coordinate(vec2 currentUV, vec2 currentScreenUV){
	// The more to the bottom we are at the water rectangle, the more to the
	// top of the screen we want the coordinate.
	float inverted_uvy = (1.0 - currentUV.y);
	// I don't want to reflect below a given vertical limit of the screen.
	float clamped_screen_uvy = mix(0, reflection_limit, inverted_uvy);
	// Get resulting UV screen coordinate to reflect on water.
	return vec2(currentScreenUV.x, clamped_screen_uvy);
}

vec4 get_resulting_water_color(vec4 mirrored_color, vec2 currentUV){
	// Improve mirrored clear colors to make them more visible.
	float mirrored_color_average = (
		mirrored_color.r + 
		mirrored_color.g + 
		mirrored_color.b) / 
		3.0;
	float highlight_factor = pow(
		mirrored_color_average, 
		mirrored_colors_intensity);
	// The more to the bottom of the water rectangle, the more water color we 
	// want.
	// TODO: This is not working as intended. A higher highlight factor should get more intense colors. Now it's happening the oppposite.
	float water_color_mix = clamp(
		currentUV.y - highlight_factor, 
		0.0, 
		water_color_intensity);
	return mix(mirrored_color, water_color, water_color_mix);
}

void fragment() {
	vec2 uv = get_mirrored_coordinate(UV, SCREEN_UV);
	// Get the reflected color.
	// WARNING: This sampling will only get colors printed on screen so far. So
	// it will only get colors from sprites with a Z-Index below the Z-Index of
	// this material's node.
	vec4 mirrored_color = texture(screen_texture, uv);
	// Mix the mirrored color with water color to get the final resulting color.
	COLOR = get_resulting_water_color(mirrored_color, UV);
}
