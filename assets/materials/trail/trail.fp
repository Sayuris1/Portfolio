uniform lowp vec4 u_color;

varying lowp vec4 var_tint;
varying mediump vec2 var_texcoord0;

//uniform highp sampler2D texture0;
uniform lowp sampler2D texture1;

//precision lowp float;

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

void main()
{
    /* vec2 res = vec2(1280.0, 720.0);
    //vec2 uv = ((gl_FragCoord.xy - 0.5 * res) / res.y) + u_pos.xy;
    vec2 uv = var_texcoord0 * 2.0 - 1.0;

    vec4 color = vec4(0.0);
    vec4 border = vec4(abs(uv.x));
    border.rgb *= vec3(0.0, 0.0, 1.0);
    color += border; */

    /* vec2 grid_uv = fract(var_pos.xy * 0.6) - 0.5;
    vec2 grid_id = floor(var_pos.xy * 0.6);
    float r = noise(grid_id);
    if (color.a < 0.7){
        if (r < 0.5)
            color += vec4(0.0, 1.0, 1.0, 1.0);
    }
    if (r < 0.3)
        color = vec4(0.0); */

    //color.rgb += vec3(0.0, 1.0, 1.0) * noise(uv + u_pos.xy);
    //color -= noise(uv + u_pos.xy * 25.0);
    
    // Pre-multiply alpha since all runtime textures already are
    lowp vec4 tint_pm = vec4(var_tint.xyz * var_tint.w, var_tint.w);
    gl_FragColor = texture2D(texture1, var_texcoord0.xy) * tint_pm * u_color;
    //gl_FragColor = color * tint_pm;
}
