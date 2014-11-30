package uk.co.mojaworks.norman.systems.renderer.shaders;

/**
 * ...
 * @author Simon
 */
class DefaultFillFragmentShader extends ShaderData
{

	public function new() 
	{
		super();
	}
	
	override public function getGLSL():String 
	{
		var str : String = "";
		
		#if !desktop
			str += "precision mediump float;";
		#end

		str += "varying vec4 vVertexColor;";
		
		str += "void main(void) {";
		str += "	gl_FragColor = vVertexColor;";
		str += "}";
		
		return str;
	}
	
}