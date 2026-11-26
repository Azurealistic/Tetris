uniform float time;

const float OUTER_BEVEL = 0.11;
const float INNER_HALF = 0.22;
const float INNER_RIM = 0.06;
const float EDGE_LINE = 0.03;
const float SMOOTH = 0.015;
const float LIGHT = 0.38;
const float DARK = 0.34;
const float INNER_STRENGTH = 0.30;
const float PIT = 0.10;
const float GRADIENT = 0.10;
const float WASH = 0.22;
const float EDGE_DARKEN = 0.35;
const float SHEEN = 0.22;
const float SHEEN_WIDTH = 0.16;
const float SHEEN_CYCLE = 16;
const float SHEEN_SWEEP = 0.8;
const float SHEEN_TRAVEL = 700.0;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen)
{
    vec4 base = Texel(tex, uv) * color;
    vec3 rgb = mix(base.rgb, vec3(0.88), WASH);
    rgb *= 1.0 + GRADIENT * (0.5 - uv.y);

    vec2 p = uv - 0.5;
    float d = max(abs(p.x), abs(p.y));
    float side = abs(p.x) > abs(p.y) ? p.x : p.y;
    float lit = 1.0 - step(0.0, side);

    float outer = smoothstep(0.5 - OUTER_BEVEL - SMOOTH, 0.5 - OUTER_BEVEL + SMOOTH, d);
    rgb = mix(rgb, vec3(lit), outer * mix(DARK, LIGHT, lit));

    float inside = 1.0 - smoothstep(INNER_HALF - SMOOTH, INNER_HALF + SMOOTH, d);
    float pit = 1.0 - smoothstep(INNER_HALF - INNER_RIM - SMOOTH, INNER_HALF - INNER_RIM + SMOOTH, d);
    rgb *= 1.0 - PIT * pit;
    rgb = mix(rgb, vec3(1.0 - lit), (inside - pit) * INNER_STRENGTH);

    rgb *= 1.0 - EDGE_DARKEN * smoothstep(0.5 - EDGE_LINE, 0.5, d);

    float phase = fract((time - (screen.x + screen.y) / SHEEN_TRAVEL) / SHEEN_CYCLE);
    float progress = phase * SHEEN_CYCLE / SHEEN_SWEEP;
    float diagonal = (uv.x + uv.y) * 0.5;
    float position = mix(-SHEEN_WIDTH, 1.0 + SHEEN_WIDTH, progress);
    float glint = (1.0 - smoothstep(0.0, SHEEN_WIDTH, abs(diagonal - position))) * (1.0 - step(1.0, progress));
    rgb += SHEEN * glint;

    return vec4(clamp(rgb, 0.0, 1.0), base.a);
}