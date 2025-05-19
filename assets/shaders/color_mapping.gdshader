shader_type canvas_item;

uniform sampler2D gradient_texture: source_color, repeat_disable;

void fragment() {
	float lightness = float(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b);
	vec4 gradient = texture(gradient_texture, vec2(lightness, 0.0));
	COLOR = gradient;
}