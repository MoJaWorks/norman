package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
class ShaderUtils
{

	public function new() 
	{
		
	}
	
	public static function getDefaultFillVertexSource() : String {
		
		var vertexSource : String = "";
		vertexSource += "attribute vec2 aVertexPosition;";
		vertexSource += "attribute vec4 aVertexColor;";
		vertexSource += "uniform mat4 uProjectionMatrix;";
		
		vertexSource += "varying vec4 vVertexColor;";
		
		vertexSource += "void main(void) {";
		vertexSource += "  vVertexColor = aVertexColor;";
		vertexSource += "  gl_Position = uProjectionMatrix * vec4(aVertexPosition, 0.0, 1.0);";
		vertexSource += "}";
		
		return vertexSource;
		
	}
	
	public static function getDefaultFillFragSource() : String 
	{
		var fragmentSource : String = "";
		#if !desktop
			fragmentSource += "precision mediump float;";
		#end
		
		fragmentSource += "varying vec4 vVertexColor;";
		fragmentSource += "void main(void) {";
		fragmentSource += "  gl_FragColor = vVertexColor;";
		fragmentSource += "}";
		
		return fragmentSource;
	}
	
}