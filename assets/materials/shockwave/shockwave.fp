//precision highp float;
uniform lowp vec4 u_in;

varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;

float circleFast(vec2 st, vec2 pos, float r) {
    vec2 dist = st - pos;
    return 1.-smoothstep(r-(0.09),r+(0.09),dot(dist,dist)*4.);
}

void main()
{
    vec2 res = vec2(1280.0, 720.0);
    vec2 uv = var_texcoord0.xy;
    vec2 pos = u_in.xy / res.xy;

    float circle_outline = circleFast(uv, pos, u_in.z) - circleFast(uv, pos, u_in.w);
    float circle_between = clamp(distance(pos, uv) * 1.2, 0.0, 1.0);

    uv += circle_outline * circle_between;
    gl_FragColor = texture2D(texture_sampler, uv);
}
