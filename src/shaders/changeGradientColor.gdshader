shader_type canvas_item;

uniform sampler2D start_gradient;
uniform sampler2D middle_gradient;
uniform sampler2D end_gradient;
uniform bool use_noise;
uniform float noise_spd_x : hint_range(-1.0, 1.0, 0.01);
uniform float noise_spd_y : hint_range(-1.0, 1.0, 0.01);
uniform float noise_brightness : hint_range(0, 1, 0.01);
uniform sampler2D noise_tex : repeat_enable;
uniform float gradient_control : hint_range(0.0, 1.0, 0.0001);
uniform float scroll_speed : hint_range(-1, 1, 0.01);
uniform float x_position : hint_range(-1, 1, 0.01);
uniform float y_position : hint_range(-1, 1, 0.01);
uniform sampler2D wave : repeat_enable;
uniform float wave_spd : hint_range(0.0, 1.0, 0.1);


vec4 changed_gradient(vec4 tex_color, vec4 gradient){ // Makes new gradient based off the original image
	//Find average of all rgb values
	float tex_average = (tex_color.r + tex_color.g + tex_color.b) / 3.;
	vec4 grayscale_tex = vec4(tex_average, tex_average, tex_average, 1);
	vec3 gradient_final = clamp(gradient.rgb + (gradient.rgb - grayscale_tex.rgb), 0, 1.);
	return vec4(gradient_final, tex_color.a);
}
//create a wave texture and wherever the wave overlaps is where the pixels will shift up
void fragment() {
	vec4 wave_tex = texture(wave, UV + vec2(TIME * wave_spd));
	vec4 tex_color = texture(TEXTURE, UV + vec2(TIME * scroll_speed + x_position, (wave_tex.r * 0.01) + y_position));
	// Noise variation
	if (use_noise){
		vec4 noise = texture(noise_tex, UV + vec2(TIME * noise_spd_x, sin(TIME * noise_spd_y)));
		tex_color.rgb = clamp(tex_color.rgb + noise.rgb * noise_brightness, 0, 1); //(clamp(noise.rgb + (1. - noise_brightness), 0, 1));
	}
	
	
	// Get all gradients after they've been processed through the original image
	vec4 first_gradient_tex = changed_gradient(tex_color, texture(start_gradient, UV));
	vec4 second_gradient_tex = changed_gradient(tex_color, texture(middle_gradient, UV));
	vec4 third_gradient_tex = changed_gradient(tex_color, texture(end_gradient, UV));
	
	//Gets distance between new gradient and previous gradient
	vec3 first_to_second_gradient_difference = second_gradient_tex.rgb - first_gradient_tex.rgb;
	vec3 second_to_third_gradient_difference = third_gradient_tex.rgb - second_gradient_tex.rgb;
	
	float t; // calculates interpolation factor so that rgb values arrive at destination at the same time
	vec4 transition;
	if(gradient_control < 0.5){
		t = min((gradient_control * 2.), 1.);
		transition = vec4(t * first_to_second_gradient_difference.rgb, 0);
		COLOR = first_gradient_tex + transition;
	} else {
		t = min(((gradient_control - 0.5) * 2.), 1.);
		transition = vec4(t * second_to_third_gradient_difference.rgb, 0);
		COLOR = second_gradient_tex + transition;
	}
}
