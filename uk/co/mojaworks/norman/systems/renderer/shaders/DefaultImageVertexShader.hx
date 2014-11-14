package uk.co.mojaworks.norman.systems.renderer.shaders;

/**
 * ...
 * @author Simon
 */
class DefaultImageVertexShader extends ShaderData
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
		str += "attribute vec2 aVertexUV;";
		str += "uniform mat4 uProjectionMatrix;";
		
		str += "varying vec4 vVertexColor;";
		str += "varying vec2 vVertexUV;";

		str += "void main(void) {";
		str += "	vVertexColor = aVertexColor;";
		str += "	vVertexUV = aVertexUV;";
		str += "	gl_Position = uProjectionMatrix * vec4(aVertexPosition, 1.0);";
		str += "}";
		
		return str;
	}
	
}