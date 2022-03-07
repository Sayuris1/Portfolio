//precision highp float;

uniform lowp vec4 u_in;
uniform lowp sampler2D texture_sampler;

varying mediump vec2 var_texcoord0;

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

float fbm (vec2 st, vec2 pos) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;

    // Loop of octaves
    for (int i = 0; i < 3; i++) {
        value += amplitude * noise(st + pos);
        st *= 2.0;
        amplitude *= .5;
    }
    return value;
}

float star_shape(vec2 uv, float flare){
    // Distance to center
    float dist = length(uv);
    float circle = 0.04 / dist;

    // uv is from -0.5 to 0.5
    // So abs gives plus sign, then make it smaller and white
    float plus = max(0.0, 1.0 - abs(uv.x * uv.y * 300.0));
    // If 0 no flare
    circle += plus * flare;

    // Needs to fade out fully before reaching neighbors neighbor.
    // Cos we only loop neighbors
    circle *= smoothstep(1.0, 0.2, dist);
    return circle;
}

vec3 star_layer(vec2 uv, float parallax){
    vec3 color = vec3(0.0);

    // Create grid, then make origin middle
    vec2 grid_uv = fract(uv) - 0.5;
    vec2 grid_id = floor(uv);

    // Add neighboring box contribitions
    // 0, 0 needs to be the main star
    for (int y = -1; y <= 1; y++){
        for (int x = -1; x <= 1; x++){
            vec2 offset = vec2(x, y);

            // Position randomly per box(id), make sure it's in bounds
            // fract(random * x) -> new random
            float random = random(grid_id + offset);
            float size = smoothstep(parallax - 0.1, parallax, fract(random * 345.6));

            // Make sure it can't pass borders by adding grid size
            // Bigger stars have bigger flare
            float star = star_shape(grid_uv - offset - vec2(random, fract(random * 10.0)) + 0.5, smoothstep(1.0, 0.9, size) * 0.3);

            // Sin returns -1 to 1
            vec3 star_color = sin(vec3(0.2, 0.3, 0.9) * fract(random * 7563.0) * 500.0) * 0.5 + 0.5;
            star_color = star_color * vec3(1.0, 1.0, 1.0 + size);

            // Make sin in 0 to 1
            // Twinkle effect
            //star *= sin(random * 500.0) * 0.5 + 1.0;
            color += star * size * star_color;
        }
    }
    
    return color;
}

void main() {
    vec2 res = vec2(1280.0, 720.0);
    vec2 uv = (gl_FragCoord.xy - 0.5 * res) / res.y;
    uv *= 2.0;
    vec2 pos = vec2(u_in.x, u_in.y);

    // Background color
    vec3 from = vec3(0.05, 0.05, 0.22) * 0.5;
    vec3 to = vec3(0.00, 0.00, 0.00);
    vec3 weight = vec3(uv.y, uv.y, uv.y);
    
    vec3 color = mix(from, to, weight) * 0.4;

    // Cloud effect
    vec3 cloud_color = vec3(0.2, 0.1, 0.5);
    color += smoothstep(0.6, 0.7, fbm(uv * 2.0, pos)) * cloud_color * 0.7;
    
    // Stars
    uv *= 10.0; // Zoom out, more repeat

    color += star_layer(uv + 9870.6 + pos, 0.5);
    color += star_layer(uv + 1230.4 + pos * 0.6, 0.8);
    color += star_layer(uv + pos * 0.3, 1.0);

    gl_FragColor = vec4(color, 1.0);
}
