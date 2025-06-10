# Persona 3 Reload. Pause Menu UI

[Русская версия](README_ru.md)

The text below is not a guide, but rather a collection of unordered notes. The project contains a lot of lazy solutions and hardcoded logic. My goal wasn't to make a reference-quality project, but to learn how to work with UI in Godot. I was inspired by the pause menu interface from *Persona 3 Reload*, and that’s what I ended up recreating.

### Demonstration

https://github.com/user-attachments/assets/808a1fa9-906e-4ff7-bc77-a09012825039

[Watch on YouTube](https://www.youtube.com/watch?v=PL8FhfQNRS4)

### References:

* Sounds by [graaveaty](https://www.youtube.com/@graaveaty).
* 3D model of Makoto was taken [from here](https://sketchfab.com/3d-models/makoto-yukiminato-arisato-persona-3-85308017127c43e991e646fa5c32b71d).
* Button images by the ubiquitous [Kenney](https://www.kenney.nl/).
* Font used: Montserrat.
* Main reference video: [this one](https://www.youtube.com/watch?v=4d6x1CIgLSc), thanks to John Persona.
* Big help came from this video by [Acerola](https://www.youtube.com/watch?v=dVWkPADNdJ4).
* Gaussian blur shader was taken [from here](https://godotshaders.com/shader/gaussian-blur-2/).

## Viewports

There are many viewports in the project. They're placed in containers and often have shaders applied to them. This approach was chosen to group nodes for rendering.

If viewports are not visible, they are not rendered (an option is enabled for that). That’s why I hide the viewports I don’t need.

The game world is placed in a separate viewport that has no HUD. This allows me to use that viewport’s texture in other shaders without worrying about the HUD.

## Opening the Menu

Opening the pause menu plays a 10-frame animation, with each frame lasting 3/60 seconds. Each frame is a square SVG image scaled to the viewport. This approach was chosen to allow better adaptation to different screen resolutions and aspect ratios.

Some frames also have additional masks so the UI doesn’t completely obscure the gameplay scene.

While I could have used `AnimationPlayer` to show the frames, I preferred to use tweens with chained callbacks and delays. So the entire animation is driven that way.

Cursor, menu options, and the 3D model are also animated using tweens.

Also, I stop rendering the game scene during this moment since nothing happens there anyway. This improves performance.

## Background

By background, I mean the blurry water-like texture in the back.

The background is complex and consists of several nodes:

1. A texture from the gameplay viewport with color mapping.
2. Sinusoidal distortion mimicking water flow.
3. Shading of the blue channel.
4. Bubbles and ripple effect one.
5. Ripple effect two.
6. Gaussian blur.
7. Gradient one.
8. Gradient two.

The color mapping converts brightness to a fixed 5-color gradient.

> Brightness is calculated using the formula `L = 0.299 * RED + 0.587 * GREEN + 0.114 * BLUE`, defined by [ITU-R BT.601](https://www.itu.int/rec/R-REC-BT.601-7-201103-I).

It seems that Persona 3 Reload uses pre-baked textures for bubbles and ripples, similar to my SVG approach. But I chose to write a shader using masks, noise, and boolean operations. It turned out nicely, especially since everything gets blurred anyway.

Now here’s the fun part: since the background is used in other shaders, it heavily impacts performance. To reduce this, I downscale it by a factor of three. Then, I apply Gaussian blur so the downscaling is barely noticeable. This reduced frame time by 40% without making it look worse.

## Menu Transitions

Scenes being transitioned are placed inside `SubViewportContainer`s. The exit animation (two circles) just tween the `progress` uniform of a shader.

The entrance animation to submenus includes an extra shader layer that scales the texture. Otherwise, the shader just masks the texture.

When opening the main menu from a submenu, I set that menu's `progress` to `0` and temporarily increase its `z-index` during the transition. Then I hide the submenu and reset the `z-index`.

Alternatively, I could’ve created several shader materials and applied them as needed to each `SubViewportContainer`.

When a menu isn’t needed, I hide its `SubViewportContainer`. Since viewports render only when visible, this also helps performance.

## Floating Character

A 3D model with falling and bobbing animations. The falling animation plays when opening the pause menu. Bobbing plays at all other times. Mesh, skeleton, animations, and camera were all set up in Blender.

The shader is fairly simple: if a fragment is transparent, it draws the background via `SCREEN_UV`. Additionally, [Fresnel](https://godotshaders.com/snippet/fresnel/) is used to highlight model edges (e.g. nose, cheeks, collar) by blending in the background color.

## Menu Options

Text is placed in a separate viewport so it can have a ripple and shimmer effect. Ripple is a sinusoidal distortion, and shimmer is done by offsetting a noise texture.

When an option is selected, it scales up via tween, changes color to black, and the shader material is removed.

To make sure the text scales from its center, its `pivot_size` must be set to `size * 0.5`. To avoid setting this manually each time, I modify it in `_ready()` and mark the script as a [@tool script](https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html). Not elegant, but effective.

When an option is deselected, it scales back and the color transitions via tweens.

## Menu Hierarchy

I just block `_input(...)` and `_process(...)` on menus I'm not currently in. Otherwise, I tried to minimize the number of viewports and keep the node structure logical. It’s far from perfect, but it works — and fixing it wouldn’t be too hard... if I weren’t lazy ;)

## Cursor

The cursor is a scene with two `Polygon2D`s (red and white) using shader masks.

It moves to the selected `Control` node and resizes to fit it using tweens. It also pulses during movement or on a timer.

The cursor has a unique `blend_add` mask shader. Its color depends on the text viewport and the color under it. If the underlying text is not blue (`blue < 0.3`), it turns red. Otherwise, it turns white. So the selected option (black text) becomes red, and other options change from bluish to white when hovered.

If there’s no text under the cursor, the polygon keeps its original color.

Here’s the shader:

```glsl
shader_type canvas_item;
render_mode blend_add;

uniform sampler2D text_viewport_texture: filter_nearest;

void fragment() {
	vec4 viewport = texture(text_viewport_texture, SCREEN_UV);
	COLOR.rgb = mix(COLOR.rgb, viewport.b < 0.3 ? vec3(1, 0, 0) : vec3(1, 1, 1), viewport.a);
}
```

## Responsive UI

I didn’t really do responsive UI. I just followed [the official guide](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html).

My target resolution is 1080p, so things will appear blurry on 1440p and 4K.

It works well on 16:9 ratios, but looks bad on something like 32:9. Anchors alone aren’t enough — textures and layout need to be adjusted. For example, the 3D background viewport’s position and size need to be recalculated, and you’d need to pass window dimensions to spatial shaders to display the background properly, etc.

## Tooltip

The tooltip in the bottom right corner turned out weird. Its size and position are calculated in code based on the text width. So the text shifts left, but the right edge remains fixed.

There’s also a dynamic white line with menu info, which is calculated based on the text above. It’s just a sequence of `─` characters that ends at the edge of the viewport. A clever but silly and ugly solution. Feel free to have a laugh at it.

## Tweens

[`Tweens`](https://docs.godotengine.org/en/stable/classes/class_tween.html) are convenient and visually pleasing. Just remember to stop a tween if you want to play a new animation. Don’t use multiple tweens on the same or related properties at once, or things might get messy.

## UISFX

I made a global `UISFX` scene (autoload) to handle UI sounds. It contains `AudioStreamPlayer`s. To play a sound, just call something like `UISFX.play_select()`. For a more generic approach, you could pass a string: `UISFX.play(&"sound_name")`.

> `&"string_name"` creates a [`StringName`](https://docs.godotengine.org/en/stable/classes/class_stringname.html). `StringName` is a hashed string, meaning it’s much cheaper to compare than a regular `String`. If your `UISFX.play(...)` uses a big `match`, it's better to use `StringName` over `String`.

