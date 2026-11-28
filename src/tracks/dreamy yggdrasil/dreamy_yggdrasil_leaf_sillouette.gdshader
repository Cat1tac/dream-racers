shader_type spatial;

uniform vec4 color : source_color;
uniform sampler2D alpha;
uniform float light_steps : hint_range(0.0, 40., 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color.rgb;
	ALPHA = texture(alpha, UV).r;
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
