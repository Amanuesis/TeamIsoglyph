shader_type canvas_item;

uniform float threshold = 0.45;
uniform float rand_seed = 1.0;

float random (vec2 st) {
    return fract(sin(dot(st.xy + rand_seed,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}
void fragment(){
	if (random(UV) < threshold) {
		COLOR.rgb = vec3(0.0);	
	} else {
		COLOR.rgb = vec3(1.0);
	}
	
}
