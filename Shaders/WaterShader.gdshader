shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 water_color: source_color;
uniform float water_color_intensity: hint_range(0.0, 1.0, 0.01) = 0.7;
uniform float mirrored_colors_intensity: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float reflection_limit: hint_range(0.0, 1.0, 0.01);
uniform sampler2D wave_noise: repeat_enable;
uniform float wave_strength: hint_range(0.0, 1.0, 0.01);
// Wave will start with 0 strength at UV.y=0 to avoid cut
// effects at the upper border of the water. Wave will get
// full distortion strength when UV.y reaches wave_threslhold.
uniform float wave_threshold: hint_range(0.0, 1.0, 0.01);
uniform float wave_speed: hint_range(0.0, 1.0, 0.01);

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
	// Enlighten mirrored colors to make them more visible.
	vec4 highlighted_color = 
		mirrored_color * (1.0 + mirrored_colors_intensity);
	highlighted_color = clamp(highlighted_color, vec4(0,0,0,0), vec4(1,1,1,1));
	// The more to the bottom of the water rectangle, the more water color we 
	// want.
	float water_color_mix = clamp(
		currentUV.y, 
		0.0, 
		water_color_intensity);
	return mix(highlighted_color, water_color, water_color_mix);
}

void fragment() {
	float wave_strength_by_distance = clamp(UV.y/wave_threshold, 0, 1);
	vec2 water_wave_offset = texture(wave_noise, UV + TIME * wave_speed).rg * 
	wave_strength_by_distance * 
	wave_strength;
	
	vec2 uv = get_mirrored_coordinate(UV, SCREEN_UV);
	// Get the reflected color.
	// WARNING: This sampling will only get colors printed on screen so far. So
	// it will only get colors from sprites with a Z-Index below the Z-Index of
	// this material's node.
	vec4 mirrored_color = texture(screen_texture, uv + water_wave_offset);
	// Mix the mirrored color with water color to get the final resulting color.
	COLOR = get_resulting_water_color(mirrored_color, UV);
}
