#language slang 2026
// Copyright (C) 2026 Kovid Goyal <kovid at kovidgoyal.net>
// Distributed under terms of the GPLv3 license.
//
// Original shader: https://gist.github.com/qwerasd205/c3da6c610c8ffe17d6d2d3cc7068f17f
// Credits: https://github.com/qwerasd205
// Bloom effect using golden spiral sample pattern.

import kitty_custom_shader_types;

// Golden spiral samples [x, y, weight] — weight is inverse of distance
// 12 of the original 24 taps (every other one, same radius) — halves GPU cost
static const float3 samples[12] = {
    float3(0.1693761725038636, 0.9855514761735895, 1.0),
    float3(-0.8464394909806497, -1.51113870578065, 0.5773502691896258),
    float3(1.681364377589461, 1.4741145918052656, 0.4472135954999579),
    float3(-2.4575847530631187, -0.9799373355024756, 0.3779644730092272),
    float3(2.997715703369726, 0.11704939884745152, 0.3333333333333333),
    float3(-3.167149933769243, 0.9844599011770256, 0.30151134457776363),
    float3(2.888202648340422, -2.1583061557896213, 0.2773500981126146),
    float3(-2.1504069972377464, 3.2211410627650165, 0.2581988897471611),
    float3(1.0130775986052671, -3.9967078676335834, 0.24253562503633297),
    float3(0.40107790291173834, 4.340407413572593, 0.22941573387056174),
    float3(-1.9209044802827355, -4.160543952132907, 0.2182178902359924),
    float3(3.3486228404946234, 3.4331800232609, 0.20851441405707477)
};

// luminance (linear RGB) where bloom starts; 0.1 ~ sRGB #595959
static const float BLOOM_THRESHOLD = 0.1f;
// luminance range over which bloom fades in above the threshold
static const float BLOOM_KNEE = 0.1f;
// strength of the bloom contribution
// static const float BLOOM_STRENGTH = 0.19f;
static const float BLOOM_STRENGTH = 0.19f;
// tames glow from bright colors (white): factor 1/(1 + COMPRESS*l), 0 = off
static const float BLOOM_COMPRESS = 1.5f;

float
lum(float4 c) {
    return 0.299f * c.r + 0.587f * c.g + 0.114f * c.b;
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float2 uv = t.pos;

    // No bloom in the active window when its background differs from the global
    // one (claude wrapper in ~/.zshrc sets #010101) — keeps Thai text sharp
    float4 g = d.active_window_geometry;
    if (any(abs(d.active_window_background.rgb - d.background.rgb) > 1e-5f) &&
        all(uv >= g.xy) && all(uv <= g.xy + g.zw))
        return color;

    // One pixel in backbuffer UV space; scale by sqrt(2) to match original step
    float2 step = float2(1.414f) / float2(d.viewport_size_pixels);

    float4 result = color;

    [ForceUnroll]
    for (int i = 0; i < 12; i++) {
        float3 s = samples[i];
        float4 sc = t.backbuffer.Sample(uv + s.xy * step);
        float l = lum(sc);
        // Soft threshold, not weighted by l, so mid-luminance colors glow too
        float w = smoothstep(BLOOM_THRESHOLD, BLOOM_THRESHOLD + BLOOM_KNEE, l);
        w /= 1.0f + BLOOM_COMPRESS * l;
        result += (float4)(w * s.z * sc * BLOOM_STRENGTH);
    }

    return result;
}
