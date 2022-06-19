shader_type canvas_item;

uniform sampler2D wall_values;
uniform bool enabled = false;
uniform bool stopped = false;

void fragment() {
	vec4 current_cell = texture(wall_values, UV);
	//Get Neighbors
	float tl = texture(wall_values, UV + vec2(-TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)).r; // Top Left
	float cl = texture(wall_values, UV + vec2(-TEXTURE_PIXEL_SIZE.x, 0)).r; // Center Left
	float bl = texture(wall_values, UV + vec2(-TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)).r; // Bottom Left
	float tc = texture(wall_values, UV + vec2(0, -TEXTURE_PIXEL_SIZE.y)).r; // Top Center
	float bc = texture(wall_values, UV + vec2(0, TEXTURE_PIXEL_SIZE.y)).r; // Bottom Center
	float tr = texture(wall_values, UV + vec2(TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)).r; // Top Right
	float cr = texture(wall_values, UV + vec2(TEXTURE_PIXEL_SIZE.x, 0)).r; // Center Right
	float br = texture(wall_values, UV + vec2(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)).r; // Bottom Right
	//CA Rules
	float count = tl + cl + bl + tc + bc + tr + cr + br;
	if (current_cell.r > 0.5) {
		if (count < 4.0) {
			COLOR = vec4(vec3(0.0), 1.0);
		} else {
			COLOR = vec4(vec3(1.0), 1.0);
		}
	} else {
		if (count > 5.0) {
			COLOR = vec4(vec3(1.0), 1.0);
		} else {
			COLOR = vec4(vec3(0.0), 1.0);
		}
	}
	if (!enabled) {
		COLOR = texture(TEXTURE,UV);
	}
	if(stopped){
		COLOR = current_cell;
	}
}