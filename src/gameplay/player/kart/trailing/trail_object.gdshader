shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon;

uniform vec4 albedo_color : source_color;

uniform sampler2D noise;
uniform sampler2D noise2;
uniform float displacement : hint_range(0.0, 1.0, 0.01);

uniform sampler2D color_gradient;

void vertex() {
	vec3 pos = VERTEX;
	vec4 noise_tex = texture(noise, vec2(UV.x, UV.y + TIME));
	vec4 noise_tex2 = texture(noise2, vec2(UV.x + TIME, UV.y));
	pos += noise_tex.r * noise_tex2.r * displacement * NORMAL;
	VERTEX = pos;
}

void fragment() {
	ALBEDO = albedo_color.rgb;
}

void light(){
	float dotproduct = clamp(dot(NORMAL, LIGHT), -1.0, 1.0);
	float sample = clamp((dotproduct + 1.0) * ATTENUATION / 2.0, 0.05, 0.95);
	vec4 shaded = texture(color_gradient, vec2(sample, 0.0));
	DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
}
