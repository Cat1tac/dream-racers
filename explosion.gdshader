shader_type spatial;

render_mode blend_add, unshaded, cull_disabled;

uniform sampler2D noise_tex : repeat_enable;
uniform sampler2D color_grad;
uniform sampler2D disappear_gradient;
uniform vec2 scale = vec2(1,1); 
uniform float speed = 1;
uniform float fill : hint_range(0.0, 1.0, 0.01);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 noise = texture(noise_tex, UV * scale + vec2(TIME * speed, 0));
	vec4 noise2 = texture(noise_tex, UV + vec2(0, sin(TIME * speed)));
	vec4 color = texture(color_grad, UV);
	vec4 disappear = texture(disappear_gradient, UV);
	ALBEDO = color.rgb;
	ALPHA = smoothstep(disappear.r, 1, fill) *  clamp(noise.r + noise2.r, 0, 1);
	EMISSION = color.rgb * 10.;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
