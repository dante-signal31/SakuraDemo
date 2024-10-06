shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 water_color: source_color;
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

void fragment() {
	vec2 uv = get_mirrored_coordinate(UV, SCREEN_UV);
	// Get the reflected color.
	vec4 mirrored_color = texture(screen_texture, uv);
	// The more to the bottom of the water rectangle, the more water color we 
	// want.
	COLOR = mix(mirrored_color, water_color, UV.y);
}
