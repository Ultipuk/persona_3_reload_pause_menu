shader_type canvas_item;
render_mode unshaded, blend_add;

#define USE_ANTIPATTERN

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest,repeat_disable;

uniform sampler2D pattern_texture: repeat_enable;
uniform sampler2D mask_texture: repeat_enable;

uniform vec4 color: source_color;
uniform vec2 velocity_main = vec2(0.0, 0.04);
uniform vec2 velocity_second = vec2(0.0, 0.04);
uniform vec2 scale_main = vec2(1.0);
uniform vec2 scale_second = vec2(1.0);
uniform float cut: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform int updates_per_second = 1;

void fragment() {
	float pattern_1 = texture(pattern_texture, scale_main * UV + velocity_main * floor(TIME * float(updates_per_second)) / float(updates_per_second)).r;
	float pattern_2 = texture(pattern_texture, scale_second * UV + 0.5 + velocity_second * floor(TIME * float(updates_per_second)) / float(updates_per_second)).r;
	float mask = texture(mask_texture, UV).r;

	float pattern = step(cut, mask - abs(pattern_1 - pattern_2));
	COLOR.a = pattern * color.a;

	//if (use_antipattern) {
		//float antipattern = step(1.0 - cut, abs(pattern_1 - pattern_2) - mask);
		//COLOR.a = (pattern + antipattern) * color.a;
	//} else {
		//COLOR.a = pattern * color.a;
	//}

	COLOR.rgb = color.rgb;
}
