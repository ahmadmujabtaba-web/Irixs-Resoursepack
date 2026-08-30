#version 330

uniform sampler2D InSampler;
uniform sampler2D BloomSampler;

in vec2 texCoord;

out vec4 fragColor;

void main() {
    vec4 mainCol = texture(InSampler, texCoord);
    vec4 bloomCol = texture(BloomSampler, texCoord);
    bloomCol *= vec4(vec3(1.0), bloomCol.a * 1.5);

    fragColor = mainCol.a < 0.1 ? bloomCol : mainCol;
}
