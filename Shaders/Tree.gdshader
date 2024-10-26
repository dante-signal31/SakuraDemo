shader_type canvas_item;
uniform float wind_strength: hint_range(0.0, 1.0, 0.01);
// To make the tree oscillation tend to left take horizontal_offset towards -1,
// To make it tend to right then take it towards +1.
uniform float horizontal_offset: hint_range(-1.0, 1.0, 0.01);
uniform float maximum_oscillation_amplitude = 300.0;
uniform float time;

void vertex() {
	// Remember that in floating point math you cannot do UV.Y == 0.0.
	if (UV.y < 0.1){
		// Using VERTEX.x inside sin() gives us a non uniform oscillation across
		// X axis. That achieves a stretching and comprising appearance.
		float oscillation = wind_strength * (sin(time + VERTEX.x) + horizontal_offset);
		float displacement = oscillation * maximum_oscillation_amplitude;
		float displaced_vertex_X = VERTEX.x + displacement;
		VERTEX = vec2(displaced_vertex_X, VERTEX.y);
	}
}
