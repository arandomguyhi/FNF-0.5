#pragma header

uniform float alphaShit;

void main() {
	vec4 color = texture2D(bitmap, openfl_TextureCoordv);
	if (color.a > 0.0)
		color -= alphaShit;

	gl_FragColor = color;
}