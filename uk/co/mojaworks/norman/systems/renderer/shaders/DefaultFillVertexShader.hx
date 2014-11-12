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
		
		str += "attribute vec3 aVertexPosition;";
		str += "attribute vec4 aVertexColor;";
		str += "uniform mat4 uProjectionMatrix;";
		
		str += "varying vec4 vVertexColor;";

		str += "void main(void) {";
		str += "	vVertexColor = aVertexColor;";
		str += "	gl_Position = uProjectionMatrix * vec4(aVertexPosition, 1.0);";
		str += "}";
		
		return str;
	}
	
}