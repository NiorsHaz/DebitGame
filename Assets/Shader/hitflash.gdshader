shader_type canvas_item;

uniform bool active = false;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (active) {
        COLOR = vec4(flash_color.rgb, tex.a);
    } else {
        COLOR = tex;
    }
}