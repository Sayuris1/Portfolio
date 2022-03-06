varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;

void main() {
    const float pi_2 = 6.28318530718; // pi_2*2
    
    // Settings
    const float directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    const float quality = 4.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
    const float size = 5.0; // BLUR SIZE (radius)
   
    vec2 iResolution = vec2(1280, 720);

    vec2 radius = size/iResolution.xy;
    vec4 color = texture2D(texture_sampler, var_texcoord0);
    
    // Blur calculations
    for( float d = 0.0; d < pi_2; d += pi_2 / directions) {
		for(float i = 1.0 / quality; i <= 1.0; i+= 1.0 / quality) {
			color += texture2D(texture_sampler, var_texcoord0 + vec2(cos(d), sin(d)) * radius * i);		
        }
    }

    // Output to screen
    color /= quality * directions - 15.0;

    gl_FragColor = color * 1.2;
}
