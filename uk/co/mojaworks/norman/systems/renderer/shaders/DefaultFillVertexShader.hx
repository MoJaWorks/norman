package uk.co.mojaworks.norman.systems.renderer.shaders;

/**
 * ...
 * @author Simon
 */
class DefaultFillVertexShader extends ShaderData
{

	public function new() 
	{
		super();
	}
	
	override public function getGLSL():String 
	{
		var str : String = "";
		
		str += "attribute vec2 aVertexPosition;";
		str += "attribute vec4 aVertexColor;";
		str += "varying vec4 vVertexColor;";

		str += "uniform mat4 uModelViewMatrix;";
		str += "uniform mat4 uProjectionMatrix;";

		str += "void main(void) {";
		str += "	vVertexColor = aVertexColor;";
		str += "	gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aVertexPosition, 0, 1.0);";
		str += "}";
	}
	
}