shader_type spatial;
render_mode cull_front, unshaded;

uniform sampler2D noise;
uniform sampler2D noise2;
uniform float displacement : hint_range(0.0, 1.0, 0.01);

uniform float outline_width : hint_range(0.0f, 0.1f) = 0.02f;
uniform vec4 outline_color : source_color = vec4(vec3(0.0f), 1.0f);

void vertex() {
	vec3 pos = VERTEX;
	vec4 noise_tex = texture(noise, vec2(UV.x, UV.y + TIME));
	vec4 noise_tex2 = texture(noise2, vec2(UV.x + TIME, UV.y));
	pos += noise_tex.r * noise_tex2.r * displacement * NORMAL;
	VERTEX = pos;
	VERTEX += NORMAL * outline_width;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
