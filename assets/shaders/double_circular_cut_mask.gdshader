shader_type canvas_item;

// Comment this if you want to use custom radius
#define USE_CIRCUMRADIUS

/** Transition of the mask effect. */
uniform float progress: hint_range(0.0, 1.0) = 0.5;
/** Center of the circle in normalized UV coordinates. */
uniform vec2 center_1 = vec2(0.5);
/** Center of the circle in normalized UV coordinates. */
uniform vec2 center_2 = vec2(0.5);
uniform float center_2_scale: hint_range(0.0, 1.0) = 0.8;

#ifndef USE_CIRCUMRADIUS
uniform float radius = 0.5;
#endif

void fragment() {
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

	// Scale coords to non-square screens.
	vec2 ar_uv = vec2(aspect_ratio * UV.x, UV.y);
	vec2 ar_center_1 = vec2(aspect_ratio * center_1.x, center_1.y);
	vec2 ar_center_2 = vec2(aspect_ratio * center_2.x, center_2.y);

	vec2 mask_1 = ar_uv - ar_center_1;
	vec2 mask_2 = ar_uv - ar_center_2;

	#ifdef USE_CIRCUMRADIUS
	float d1 = distance(ar_center_1, vec2(0.0, 0.0));
	float d2 = distance(ar_center_1, vec2(0.0, 1.0));
	float d3 = distance(ar_center_1, vec2(aspect_ratio * 1.0, 0.0));
	float d4 = distance(ar_center_1, vec2(aspect_ratio * 1.0, 1.0));
	float radius = max(max(d1, d2), max(d3, d4));
	#endif

	COLOR.a = COLOR.a * (1.0 - step(progress * radius, length(mask_1)) * step(progress * radius * center_2_scale, length(mask_2)));
}