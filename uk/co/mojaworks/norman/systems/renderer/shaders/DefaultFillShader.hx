package uk.co.mojaworks.norman.systems.renderer.shaders;

/**
 * ...
 * @author Simon
 */
class DefaultFillShader extends ShaderData
{

	public static inline var ID : String = "DefaultFillShader";
	
	public function new() 
	{
		super();
		id = ID;
	}
	
	override function setupVertexSource():Void 
	{
		
		vertexSource = "";
		vertexSource += "attribute vec2 aVertexPosition;";
		vertexSource += "attribute vec4 aVertexColor;";
		vertexSource += "uniform mat4 uProjectionMatrix;";
		
		vertexSource += "varying vec4 vVertexColor;";
		
		vertexSource += "void main(void) {";
		vertexSource += "  vVertexColor = aVertexColor;";
		vertexSource += "  gl_Position = uProjectionMatrix * vec4(aVertexPosition, 0.0, 1.0);";
		vertexSource += "}";
		
	}
	
	override function setupFragmentSource():Void 
	{
		fragmentSource = "";
		#if !desktop
			fragmentSource += "precision mediump float;";
		#end
		
		fragmentSource += "varying vec4 vVertexColor;";
		fragmentSource += "void main(void) {";
		fragmentSource += "  gl_FragColor = vVertexColor;";
		fragmentSource += "}";
	}
	
}