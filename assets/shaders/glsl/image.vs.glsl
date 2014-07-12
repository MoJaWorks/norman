attribute vec2 aVertexPosition;
attribute vec4 aVertexColor;
attribute vec2 aTexCoord;
varying vec2 vTexCoord;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

varying vec4 vVertexColor;

void main(void) {
	vTexCoord = aTexCoord;
	vVertexColor = aVertexColor;
	gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aVertexPosition, 0.0, 1.0);
}