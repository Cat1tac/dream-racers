shader_type spatial;

uniform sampler2D albedo;
uniform sampler2D noise;
uniform vec2 scroll_spd;
uniform float height_displacement : hint_range(0.0, 1.0, 0.01);

void vertex() {
	vec3 pos = VERTEX;
	vec4 noise_tex = texture(noise, UV + (TIME * scroll_spd));
	pos.y += noise_tex.r * height_displacement;
	VERTEX = pos;
}

void fragment() {
	vec4 noise_tex = texture(noise, UV + (TIME * scroll_spd));
	vec4 albedo_tex = texture(albedo, vec2(noise_tex.r));
	ALBEDO = albedo_tex.rgb;
	//ALPHA = albedo_tex.a * noise_tex.r;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
