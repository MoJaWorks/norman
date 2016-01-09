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
		
		var str : String = "";
		
		#if !mac
			str += "precision mediump float;";
		#end
		
		str += "attribute vec2 aVertexPosition;";
		str += "attribute vec4 aVertexColor;";
		str += "uniform mat4 uProjectionMatrix;";
		
		str += "varying vec4 vVertexColor;";
		
		str += "void main(void) {";
		str += "  vVertexColor = aVertexColor;";
		str += "  gl_Position = uProjectionMatrix * vec4(aVertexPosition, 0.0, 1.0);";
		str += "}";
		
		return str;
		
	}
	
	public static function getDefaultFillFragSource() : String 
	{
		var str : String = "";
		
		#if !mac
			str += "precision mediump float;";
		#end
		
		str += "varying vec4 vVertexColor;";
		str += "void main(void) {";
		str += "  gl_FragColor = vVertexColor;";
		str += "}";
		
		return str;
	}
	
	
	/**
	 * Image shader
	 * @return
	 */
	
	public static function getDefaultImageVertexSource():String 
	{
		var str : String = "";
		
		#if !mac
			str += "precision mediump float;";
		#end
		
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
	
	
	public static function getDefaultImageFragSource():String 
	{
		var str : String = "";
		
		#if !mac
			str += "precision mediump float;";
		#end

		str += "varying vec4 vVertexColor;";
		str += "varying vec2 vVertexUV;";
		str += "uniform sampler2D uTexture0;";
		
		str += "void main(void) {";
		str += "	vec4 texColor = texture2D( uTexture0, vVertexUV );";
		str += "	texColor.rgb = texColor.rgb * texColor.a;";
		str += "	gl_FragColor = vVertexColor * texColor;";
		str += "}";
		
		return str;
	}
	
	
	public static function getDefaultRenderTextureFragSource():String 
	{
		
		var str : String = "";
		
		#if !mac
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
	
	public static function getDefaultMaskVertexSource():String 
	{
		var str : String = "";
		
		#if !mac
			str += "precision mediump float;";
		#end
		
		str += "attribute vec2 aVertexPosition;";
		str += "attribute vec2 aMaskUV;";
		str += "attribute vec2 aVertexUV;";
		str += "attribute float aVertexAlpha;";
		str += "uniform mat4 uProjectionMatrix;";
		
		str += "varying vec2 vMaskUV;";
		str += "varying vec2 vVertexUV;";
		str += "varying float vVertexAlpha;";

		str += "void main(void) {";
		str += "	vMaskUV = aMaskUV;";
		str += "	vVertexUV = aVertexUV;";
		str += "	vVertexAlpha = aVertexAlpha;";
		str += "	gl_Position = uProjectionMatrix * vec4(aVertexPosition, 0.0, 1.0);";
		str += "}";
		
		return str;
	}
	
	public static function getDefaultMaskFragSource():String 
	{
		
		var str : String = "";
		
		#if !mac
			str += "precision mediump float;";
		#end

		str += "varying vec2 vMaskUV;";
		str += "varying vec2 vVertexUV;";
		str += "varying float vVertexAlpha;";
		
		str += "uniform sampler2D uTexture0;";
		str += "uniform sampler2D uTexture1;";
		
		str += "void main(void) {";
		str += "	gl_FragColor = texture2D( uTexture0, vVertexUV );";
		str += "	gl_FragColor = gl_FragColor * texture2D( uTexture1, vMaskUV ).a;";
		str += "	gl_FragColor = gl_FragColor * vVertexAlpha;";
		str += "}";
		
		return str;
		
	}
	
}