shader_type canvas_item;
uniform float wind_strength: hint_range(0.0, 10.0, 0.01);
// To make the tree oscillation tend to left take horizontal_offset towards -1,
// To make it tend to right then take it towards +1.
uniform float horizontal_offset: hint_range(-1.0, 1.0, 0.01);
uniform float time;

void vertex() {
	// Remember that in floating point math you cannot do VERTEX.Y == 0.0. 
	if (VERTEX.y < 0.1){
		// We want the root to stay in place, we only want to move the upper
		// part of the tree, so the VERTEX where Y=0.
		float displacement_factor_by_height = 1.0 - VERTEX.y;
		// Using VERTEX.x inside sin() gives us a non uniform oscillation across
		// X axis. That achieves a stretching a comprising appearance. 
		float oscillation = wind_strength * (sin(time + VERTEX.x) + horizontal_offset);
		float displacement_by_height = oscillation * displacement_factor_by_height;
		float displaced_vertex_X = VERTEX.x + displacement_by_height;
		VERTEX = vec2(displaced_vertex_X, VERTEX.y); 
	}
}
