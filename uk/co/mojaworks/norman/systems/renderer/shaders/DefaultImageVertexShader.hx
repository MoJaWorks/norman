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
		
		str += "attribute vec2 aVertexPosition;";
		str += "attribute vec4 aVertexColor;";
		str += "attribute vec2 aVertexUV;";
		str += "uniform mat4 uProjectionMatrix;";
		
		str += "varying vec4 vVertexColor;";
		str += "varying vec2 vVertexUV;";

		str += "void main(void) {";
		str += "	vVertexColor = aVertexColor;";
		str += "	vVertexUV = aVertexUV;";
		str += "	gl_Position = uProjectionMatrix * vec4(aVertexPosition, 0.0, 1.0);";
		str += "}";
		
		return str;
	}
	
	override public function getAGAL():String 
	{
		var str : String = "";
		
		str += "m44 op, va0, vc0\n";
		str += "mov v0, va1\n";
		str += "mov v1, va2";
		
		return str;
	}
	
}