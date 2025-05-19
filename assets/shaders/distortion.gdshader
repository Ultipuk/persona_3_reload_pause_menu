shader_type canvas_item;

uniform float amplitude = 0.1;
uniform float speed = 10.0;
uniform float wave_length = 2.0;
uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	vec2 scaled_uv = vec2(amplitude) + SCREEN_UV * (1.0 - amplitude * 2.);
	vec4 color = texture(screen_texture, scaled_uv + vec2(0.0, sin(SCREEN_UV.x  / wave_length + TIME * speed)) * amplitude);
	COLOR = color;
}