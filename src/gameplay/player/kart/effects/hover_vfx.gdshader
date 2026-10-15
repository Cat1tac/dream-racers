shader_type spatial;
render_mode unshaded;
uniform float speed : hint_range(0.0, 2.0) = 1.;
uniform float opacity : hint_range(0.0, 1.0) = 1;
const vec2 center = vec2(0.5);

void vertex() {
}

void fragment() {
	float outer_circle = step(distance(UV, center), fract( speed * TIME));
	float borderfade = smoothstep(distance(UV, center), 0.55 , 0.5);
	float border = step(distance(UV, center), 0.5);
	float outer_ring = step(fract((speed * TIME) - 0.1) , distance(UV, center));
	
	float inner_circle = step(distance(UV, center), fract((speed * TIME) - 0.3));
	float inner_ring = step(fract((speed * TIME) - 0.4), distance(UV, center));
	
	float innerer_circle = step(distance(UV, center), fract((speed * TIME) - 0.6));
	float innerer_ring = step(fract((speed * TIME) - 0.7), distance(UV, center));
	
	float ripples = outer_circle * outer_ring + inner_circle * inner_ring + innerer_circle * innerer_ring;
	
	ALBEDO = vec3(ripples);
	ALPHA = border * borderfade * ripples * opacity;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
