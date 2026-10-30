shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 5.0, 0.1);
uniform vec3 step_amount;
//uniform float radius : hint_range(0.0, 1.0, 0.1);

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec3 result = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount).rgb;
	ALBEDO = result;
	// Called for every pixel the material is visible on.
}



//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
