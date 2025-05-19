shader_type canvas_item;

uniform float spawn_progress: hint_range(0.0, 1.0) = 1.0;
uniform vec2 spawn_offset;

uniform float speed: hint_range(0.0, 10.0, 0.01) = 1.0;
uniform float period: hint_range(0.0, 1000.0, 0.01) = 100.0;
uniform float amplitude: hint_range(0.0, 0.01, 0.0001) = 0.004;

uniform sampler2D flare_texture: repeat_enable;
uniform vec3 flare_albedo: source_color = vec3(1.0);
uniform float flare_strength: hint_range(0.0, 2.0) = 1.0;
uniform float flare_speed: hint_range(0.0, 1.0) = 0.05;


void vertex() {
	VERTEX += spawn_offset * spawn_progress;
}


void fragment() {
	vec2 uv = UV;
	uv.x = uv.x + sin(uv.y * period + TIME * speed) * amplitude;
	COLOR = texture(TEXTURE, uv) * COLOR;
	
	float flare = texture(flare_texture, SCREEN_UV + TIME * flare_speed).r;
	COLOR.rgb += flare * flare_albedo * flare_strength;
}