attribute vec2 aVertexPosition;
attribute vec2 aTexCoord;
varying vec2 vTexCoord;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

void main(void) {
	vTexCoord = aTexCoord;
	gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aVertexPosition, 0.0, 1.0);
}