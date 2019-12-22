
***GPUImage自定义抖音分屏滤镜***

···
//分屏GLSL
precision highp float;
varying highp vec2 textureCoordinate;
uniform sampler2D inputImageTexture;

void main() {
vec2 uv = textureCoordinate.xy;
float y;
if (uv.y >= 0.0 && uv.y <= 0.5) {
y = uv.y + 0.25;
} else {
y = uv.y - 0.25;
}
gl_FragColor = texture2D(inputImageTexture, vec2(uv.x, y));
}
···
