shader_type canvas_item;

uniform float start_x : hint_range(-0.1, 0.1, 0.01);
uniform float start_y : hint_range(-0.1, 0.1, 0.01);
uniform float amplitude_x : hint_range(-0.1, 0.1, 0.001);
uniform float amplitude_y : hint_range(-0.1, 0.1, 0.001);
uniform float frequency : hint_range(-10.0, 10.0, 0.1);
uniform float selected_x : hint_range(-0.1, 0.1, 0.01);
uniform float selected_y : hint_range(-0.1, 0.1, 0.01);
uniform bool selected;
uniform vec4 selected_color : source_color;
uniform vec4 color_to_keep : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base_tex = texture(TEXTURE, vec2(UV.x + start_x, UV.y + start_y));
	
	if (!selected) {
		base_tex = texture(TEXTURE, vec2(UV.x + (amplitude_x * sin(TIME * frequency) + start_x), UV.y + (amplitude_y * sin(TIME * frequency)) + start_y));
	} else {
		base_tex = texture(TEXTURE, vec2(UV.x + selected_x + start_x, UV.y + selected_y + start_y));
		if (base_tex.rgb != color_to_keep.rgb){
			base_tex.rgb =  mix(base_tex.rgb, selected_color.rgb, 1);
		}
		
	}
	COLOR = base_tex;
}
