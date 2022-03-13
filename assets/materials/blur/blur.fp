varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;

uniform vec4 u_dir;

void main() {
	vec4 color = vec4(0.0);
    
	//apply blurring, using a 9-tap filter with predefined gaussian weights
	color += texture2D(texture_sampler, vec2(var_texcoord0.x - 0.00625  * u_dir.x, var_texcoord0.y - 0.01111111111 * u_dir.y)) * 0.0162162162;
	color += texture2D(texture_sampler, vec2(var_texcoord0.x - 0.0046875  * u_dir.x, var_texcoord0.y - 0.00833333333 * u_dir.y)) * 0.0540540541;
	color += texture2D(texture_sampler, vec2(var_texcoord0.x - 0.003125  * u_dir.x, var_texcoord0.y - 0.00555555555 * u_dir.y)) * 0.1216216216;
	color += texture2D(texture_sampler, vec2(var_texcoord0.x - 0.0015625  * u_dir.x, var_texcoord0.y - 0.00277777777 * u_dir.y)) * 0.1945945946;

	color += texture2D(texture_sampler, var_texcoord0) * 0.2270270270;
	
	color += texture2D(texture_sampler, vec2(var_texcoord0.x + 0.0015625  * u_dir.x, var_texcoord0.y + 0.00277777777 * u_dir.y)) * 0.1945945946;
	color += texture2D(texture_sampler, vec2(var_texcoord0.x + 0.003125  * u_dir.x, var_texcoord0.y + 0.00555555555 * u_dir.y)) * 0.1216216216;
	color += texture2D(texture_sampler, vec2(var_texcoord0.x + 0.0046875  * u_dir.x, var_texcoord0.y + 0.00833333333 * u_dir.y)) * 0.0540540541;
	color += texture2D(texture_sampler, vec2(var_texcoord0.x + 0.00625  * u_dir.x, var_texcoord0.y + 0.01111111111 * u_dir.y)) * 0.0162162162;

	gl_FragColor = color;
}
