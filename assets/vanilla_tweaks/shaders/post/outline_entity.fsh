#version 330

uniform sampler2D InSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform OutlineConfig {
    float InnerAlpha;
    float Width;
};

in vec2 texCoord;

out vec4 fragColor;

void main() {
    vec2 oneTexel = Width / InSize;

    vec4 center = texture(InSampler, texCoord);
    vec4 left = texture(InSampler, texCoord - vec2(oneTexel.x, 0.0));
    vec4 right = texture(InSampler, texCoord + vec2(oneTexel.x, 0.0));
    vec4 up = texture(InSampler, texCoord - vec2(0.0, oneTexel.y));
    vec4 down = texture(InSampler, texCoord + vec2(0.0, oneTexel.y));

    if(center.a < 0.1) {
        // spread rgb values out a bit so we dont blur into black later on
        if(left.a > 0.1) center.rgb = left.rgb;
        else if(right.a > 0.1) center.rgb = right.rgb;
        else if(up.a > 0.1) center.rgb = up.rgb;
        else if(down.a > 0.1) center.rgb = down.rgb;
    }

    float leftDiff  = abs(center.a - left.a);
    float rightDiff = abs(center.a - right.a);
    float upDiff    = abs(center.a - up.a);
    float downDiff  = abs(center.a - down.a);
    float total = clamp(leftDiff + rightDiff + upDiff + downDiff, InnerAlpha, 1.0);

    fragColor = vec4(center.rgb, total * center.a);
}
