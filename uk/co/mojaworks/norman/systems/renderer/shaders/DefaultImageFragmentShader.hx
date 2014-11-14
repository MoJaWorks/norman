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
		
		#if mobile
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
	
}