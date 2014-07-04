attribute vec2 aVertexPosition;
attribute vec4 aVertexColor;
varying vec4 vVertexColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

void main(void) {
	vVertexColor = aVertexColor;
	gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aVertexPosition, 0, 1.0);
}