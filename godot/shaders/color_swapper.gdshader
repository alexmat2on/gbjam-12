shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec3 original_palette[4] : source_color;
uniform vec3 new_palette[4] : source_color;

bool color_matches(vec3 color1, vec3 color2) {
	float epsilon = 0.01;
    bool red = color1.r > color2.r - epsilon && color1.r < color2.r + epsilon;
	bool green = color1.g > color2.g - epsilon && color1.g < color2.g + epsilon;
	bool blue = color1.b > color2.b - epsilon && color1.b < color2.b + epsilon;

	return red && green && blue;
}

void swap_color(vec3 old_color, vec3 new_color, vec4 current_color, inout vec4 out_color) {
	if (current_color.a == 1.0 && color_matches(current_color.rgb, old_color)) {
		out_color = vec4(new_color, 1.0);
	}
}

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);

	swap_color(original_palette[0], new_palette[0], screen_color, COLOR);
	swap_color(original_palette[1], new_palette[1], screen_color, COLOR);
	swap_color(original_palette[2], new_palette[2], screen_color, COLOR);
	swap_color(original_palette[3], new_palette[3], screen_color, COLOR);

	// Called for every pixel the material is visible on.
}