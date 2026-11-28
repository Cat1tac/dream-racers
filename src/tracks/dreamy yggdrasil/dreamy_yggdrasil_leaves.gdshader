shader_type spatial;
render_mode specular_disabled, cull_disabled;

global uniform float wind_scale;
global uniform float wind_speed;
global uniform float wind_strength;
global uniform vec3 wind_direction;
global uniform sampler2D wind_noise : filter_linear_mipmap;

uniform float leaf_bend_amount = 0.7;

uniform vec4 color : source_color;
uniform sampler2D alpha;
uniform float light_steps : hint_range(0.0, 40., 1);
uniform float fade_angle_amt : hint_range(0.0, 1.0, 0.01);
uniform float leaves_scale = 1;

uniform sampler2D depth_tex : hint_depth_texture;

varying vec4 vertx;

void vertex() {
	vec4 world_pos = MODEL_MATRIX * vec4(VERTEX, 1.0);
	float speed = TIME * wind_speed;

	float noise_texture = textureLod(wind_noise, (world_pos.xz * wind_scale) - (speed * wind_direction.xz), 1.0).r;
	noise_texture = (noise_texture * 2. - 1.) * (wind_strength * leaf_bend_amount);
//
	vec4 new_position = vec4(UV.y, UV.x, 0, 1.0); //Makes leaf cover entire UV Space
	new_position = new_position * 2. - 1.; //remaps default UV values from 0 - 1 to -1 - 1
	//new_position = normalize(new_position);
	vertx = new_position;
	new_position += noise_texture * vec4(1.0, 0.0, 0.0, 0.0) * (UV.x * 2.0 -1.0) - noise_texture * vec4(0.0, 1.0, 0.0, 0.0) * (UV.y * 2.0 -1.0);
	new_position *= leaves_scale;
	new_position *= MODELVIEW_MATRIX;
	VERTEX += new_position.xyz;
	//// Billboard
	//MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			//vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			//vec4(0.0, 1.0, 0.0, 0.0),
			//vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			//MODEL_MATRIX[3]);
//
	//// Billboard Keep Scale: Enabled
	//MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
			//vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
			//vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
			//vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
			//vec4(0.0, 0.0, 0.0, 1.0));
	//MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	
	
}

void fragment() {
	//float angle = dot(NORMAL, VIEW);
	
	
	ALBEDO = color.rgb;
	ALPHA = texture(alpha, UV).r;//* smoothstep(0, 1, clamp(angle, fade_angle_amt, 1));
	ALPHA_SCISSOR_THRESHOLD = 0.5;
	ROUGHNESS = 0.0;
	SPECULAR = 0.0;
}

void light() {
	//Cel shading
	float light = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	light = round(light * light_steps) / light_steps;
	DIFFUSE_LIGHT += light * (LIGHT_COLOR / PI) * ATTENUATION;
	
	//Rim light
	float rim = 1.0 - dot(NORMAL, VIEW);
	rim *= light;
	rim = round(rim * light_steps) / light_steps;
	rim = rim * rim;
	DIFFUSE_LIGHT += rim * ATTENUATION * LIGHT_COLOR / PI;
}
