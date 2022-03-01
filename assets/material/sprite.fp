varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
    dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
    dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
    mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
    dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec2 u_resolution = vec2(300, 300);
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 text = texture2D(texture_sampler, var_texcoord0.xy);
    if (text.a == 1)
    text += smoothstep(.18,.2,noise(st));
    gl_FragColor = text  * tint_pm;
}
