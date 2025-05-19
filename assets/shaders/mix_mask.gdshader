shader_type canvas_item;

uniform sampler2D texture_1: source_color;
uniform sampler2D texture_2: source_color;
/** Using red channel for mask. **/
uniform sampler2D mask_texture: source_color;

void fragment() {
	vec4 color_1 = texture(texture_1, SCREEN_UV);
	vec4 color_2 = texture(texture_2, SCREEN_UV);
	float mask = texture(mask_texture, UV).r;

	vec4 color = mix(color_1, color_2, mask);
	COLOR = color;
}