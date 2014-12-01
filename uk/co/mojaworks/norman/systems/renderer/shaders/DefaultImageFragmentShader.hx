package uk.co.mojaworks.norman.systems.renderer.shaders;

/**
 * ...
 * @author Simon
 */
class DefaultImageFragmentShader extends ShaderData
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
		str += "varying vec2 vVertexUV;";
		str += "uniform sampler2D uTexture0;";
		
		str += "void main(void) {";
		str += "	gl_FragColor = vVertexColor * texture2D( uTexture0, vVertexUV );";
		str += "}";
		
		return str;
	}
	
	override public function getAGAL():String 
	{
		var str : String = "";
		
		str += "tex ft0, v1, fs0 <2d, linear, nomip>\n";
		str += "mul oc, ft0, v0";
		
		return str;
	}
	
}