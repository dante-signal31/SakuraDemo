shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 water_color: source_color;
uniform float reflection_limit: hint_range(0.0, 1.0, 0.01);

void fragment() {
	float inverted_uvy = SCREEN_UV.y - UV.y;
	// I don't want to reflect below a given vertical limit of the screen.
	float clamped_screen_uvy = mix(0, reflection_limit, inverted_uvy);
	vec2 uv = vec2(SCREEN_UV.x, clamped_screen_uvy);
	vec4 mirrored_color = texture(screen_texture, uv);
	COLOR = mix(mirrored_color, water_color, UV.y);
}
