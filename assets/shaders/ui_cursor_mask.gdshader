shader_type canvas_item;
render_mode blend_add;

uniform sampler2D text_viewport_texture: filter_nearest;

void fragment() {
	vec4 viewport = texture(text_viewport_texture, SCREEN_UV);
	COLOR.rgb = mix(COLOR.rgb, viewport.b < 0.3 ? vec3(1, 0, 0) : vec3(1, 1, 1), viewport.a);
}