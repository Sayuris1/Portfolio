//precision highp float;

uniform lowp vec4 u_in;
uniform lowp vec4 tint;
uniform lowp sampler2D texture_sampler;

varying mediump vec2 var_texcoord0;

float random (vec2 st) {
    return fract(texture2D(texture_sampler, st * 0.08).y * 1.9867);
}

float fbm (vec2 st, vec2 pos) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;

    // Loop of octaves
    for (int i = 0; i < 3; i++) {
        value += amplitude * texture2D(texture_sampler, (st + pos)).x;
        st *= 2.0;
        amplitude *= .8;
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
            float size = smoothstep(parallax - 0.1, parallax, fract(random * 5.6));

            // Make sure it can't pass borders by adding grid size
            // Bigger stars have bigger flare
            float star = star_shape(grid_uv - offset - vec2(random, fract(random * 10.0)) + 0.5, smoothstep(1.0, 0.9, size) * 0.3);

            // Sin returns -1 to 1
            vec3 star_color = sin(vec3(0.2, 0.3, 0.9) * fract(random * 10.98) * 500.0) * 0.5 + 0.5;
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
    const vec2 res = vec2(1280.0, 720.0);
    vec2 uv = var_texcoord0;
    uv *= 2.0;
    vec2 pos = u_in.xy;

    // Background color
    const vec3 from = vec3(0.05, 0.05, 0.22) * 0.5;
    const vec3 to = vec3(0.00, 0.00, 0.00);
    vec3 weight = vec3(uv.y, uv.y, uv.y);
    
    vec3 bg = mix(from, to, weight) * 0.5;

    vec3 color = vec3(0.0);
    // Cloud effect
    const vec3 cloud_color = vec3(0.2, 0.1, 0.5);
    color += smoothstep(0.6, 0.7, fbm(uv * 0.05, pos * 0.05)) * cloud_color * 0.5;
    
    // Stars
    uv *= 10.0; // Zoom out, more repeat

    color += star_layer(uv + 10.0 + pos * 0.8, 1.0);
    color += star_layer(uv - 10.0 + pos * 0.6, 0.5);
    color += star_layer(uv + pos * 0.3, 0.3);

    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    gl_FragColor = vec4(color, 1.0) * tint_pm + vec4(bg, 1.0);
}
