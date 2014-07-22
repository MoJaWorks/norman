precision mediump float;

varying vec4 vVertexColor;
varying vec2 vTexCoord;
uniform sampler2D uImage0;

void main(void) {
	gl_FragColor = vVertexColor * texture2D(uImage0, vTexCoord);
}