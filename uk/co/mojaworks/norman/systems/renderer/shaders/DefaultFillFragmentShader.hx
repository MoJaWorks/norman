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
		
		#if mobile
			str += "precision mediump float;";
		#end

		str += "varying vec4 vVertexColor;";
		
		str += "void main(void) {";
		str += "	gl_FragColor = vVertexColor;";
		str += "}";
	}
	
}