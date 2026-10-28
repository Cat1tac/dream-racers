shader_type spatial;
render_mode unshaded, depth_prepass_alpha, shadows_disabled;
uniform sampler2D noisetx: repeat_enable;
uniform sampler2D add_gradient;
uniform sampler2D subtract_gradient;
uniform sampler2D color_gradient;
uniform sampler2D disappaer_gradient;

uniform sampler2D displacement_tex; 
uniform sampler2D displacement_mask;
uniform sampler2D elongate_mask; 

uniform float speed = 1;
uniform vec2 scale = vec2(1, 1);
uniform float fill : hint_range(0.0, 1.0, 0.1);
uniform float displacement_scale = 1;
uniform float displacement_speed = 1;
uniform float elongate : hint_range(0.0, 1.0, 0.01);


void vertex() {
	vec3 pos = VERTEX;
	vec4 displace_mask = texture(displacement_mask, UV);
	vec4 displacement = texture(displacement_tex, UV + vec2(0, TIME * displacement_speed));
	vec4 elongate_grad = texture(elongate_mask, UV);
	
	pos.xy += displacement_scale * elongate * displace_mask.r * (displacement.r * NORMAL).xy;
	//pos.y += displacement_scale * displace_mask.r * displacement.r;
	pos.z *= smoothstep(elongate_grad.r, 1, elongate);
	VERTEX = pos;
}

void fragment() {
	vec4 noise_y = texture(noisetx, (UV * scale) + vec2(0, TIME * speed));
	vec4 noise_x = texture(noisetx, (UV * scale) + vec2(TIME * speed, 0));
	vec4 add_tex = texture(add_gradient, UV + vec2(0, TIME * displacement_speed));
	vec4 sub_tex = texture(subtract_gradient, UV);
	vec4 disappear_tex = texture(disappaer_gradient, UV);
	
	float noise_alpha_pattern = clamp(clamp(noise_y.r + noise_x.r, 0, 1) - sub_tex.r + add_tex.r, 0, 1);
	vec4 color_tex = texture(color_gradient, UV);
	
	ALBEDO = color_tex.rgb;
	ALPHA = smoothstep(disappear_tex.r, 1, fill) * noise_alpha_pattern;
	EMISSION = color_tex.rgb * 2.;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
