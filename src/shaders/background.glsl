extern number time;
extern vec2 resolution;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen_coords)
{
    // Normalized screen coordinates
    vec2 p = screen_coords / resolution;

    // Aspect ratio correction
    p.x *= resolution.x / resolution.y;

    // Slowly moving fluid distortion
    float t = time * 0.12;

    float wave1 = sin(p.x * 3.0 + t + sin(p.y * 4.0 + t));
    float wave2 = cos(p.y * 4.0 - t * 0.7 + sin(p.x * 3.0 - t));
    float wave3 = sin((p.x + p.y) * 3.0 + t * 0.5);

    float fluid = (wave1 + wave2 + wave3) / 3.0;

    // Metallic gradient
    float metallic = smoothstep(-0.7, 0.8, fluid);

    vec3 black = vec3(0.012, 0.014, 0.018);
    vec3 silver = vec3(0.075, 0.080, 0.090);

    vec3 finalColor = mix(black, silver, metallic * 0.45);

    // Very subtle edge darkening
    vec2 centered = uv - 0.5;
    float vignette = 1.0 - dot(centered, centered) * 0.8;

    finalColor *= vignette;

    return vec4(finalColor, 1.0);
}
