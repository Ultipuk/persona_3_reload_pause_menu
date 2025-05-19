shader_type canvas_item;
render_mode unshaded, blend_add;

#define USE_ANTIPATTERN

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable;

uniform sampler2D pattern_texture: repeat_enable;
uniform sampler2D pattern_mask_texture: repeat_enable;
uniform sampler2D bubbles_texture: repeat_enable;
uniform sampler2D bubbles_mask_texture: repeat_enable;

uniform vec4 color: source_color;
uniform vec2 velocity_main = vec2(0.0, 0.04);
uniform vec2 velocity_second = vec2(0.0, 0.04);
uniform vec2 velocity_bubbles = vec2(0.0, 0.04);
uniform vec2 scale_main = vec2(1.0);
uniform vec2 scale_second = vec2(1.0);
uniform vec2 scale_bubbles = vec2(1.0);
uniform float cut: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform int updates_per_second = 1;

void fragment() {
	float pattern_1 = texture(pattern_texture, scale_main * UV + velocity_main * floor(TIME * float(updates_per_second)) / float(updates_per_second)).r;
	float pattern_2 = texture(pattern_texture, scale_second * UV + 0.5 + velocity_second * floor(TIME * float(updates_per_second)) / float(updates_per_second)).r;
	float bubbles = texture(bubbles_texture, scale_bubbles * UV + 0.5 + velocity_bubbles * floor(TIME * float(updates_per_second)) / float(updates_per_second)).r;

	float pattern_mask = texture(pattern_mask_texture, UV).r;
	float bubbles_mask = texture(bubbles_mask_texture, UV).r;

	float pattern = step(cut, pattern_mask - abs(pattern_1 - pattern_2));
	float b_pattern_1 = step(cut, bubbles - pattern - bubbles_mask);
	float b_pattern_2 = step(1.0 - cut, pattern - bubbles);
	COLOR.a = (b_pattern_1 + b_pattern_2) * color.a;

	COLOR.rgb = color.rgb;
}
