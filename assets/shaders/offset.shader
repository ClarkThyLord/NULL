shader_type canvas_item;

uniform float size_x=0.005;
uniform float size_y=0.005;

uniform float r_offset_x = -0.2;
uniform float r_offset_y = 0;
uniform float g_offset_x = 0;
uniform float g_offset_y = 0;
uniform float b_offset_x = 0.2;
uniform float b_offset_y = 0;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv-=mod(uv,vec2(size_x,size_y));
	
	vec2 PixelSize = TEXTURE_PIXEL_SIZE;
	vec4 r_val = texture(SCREEN_TEXTURE, uv + vec2(r_offset_x, r_offset_y) * PixelSize);
	vec4 g_val = texture(SCREEN_TEXTURE, uv + vec2(g_offset_x, g_offset_y) * PixelSize);
	vec4 b_val = texture(SCREEN_TEXTURE, uv + vec2(b_offset_x, b_offset_y) * PixelSize);
	
	vec3 Chromatic_Aberration = vec3(r_val.r, g_val.g, b_val.b);
	
	
	COLOR.rgb= textureLod(SCREEN_TEXTURE,uv,0.0).rgb;
}