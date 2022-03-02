uniform lowp vec4 u_in;

varying lowp vec2 var_xy;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float fbm (vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;

    vec2 pos = vec2(u_in.x, u_in.y);
 
    // Loop of octaves
    for (int i = 0; i < 3; i++) {
        value += amplitude * noise(st + pos);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

void main() {
    vec2 st = gl_FragCoord.xy/vec2(640.0, 720.0);

    vec3 from = vec3(0.05, 0.05, 0.22);
    vec3 to = vec3(0.01, 0.01, 0.044);
    vec3 weight = vec3(st.y, st.y, st.y);
    
    vec3 color = mix(from, to, weight);
    color += smoothstep(0.6, 0.7, fbm(var_xy * 2.0)) * 0.1;
    
    gl_FragColor = vec4(color, 1.0);
}
