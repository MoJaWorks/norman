package uk.co.mojaworks.norman.systems.renderer.shaders ;

/**
 * ...
 * @author Simon
 */
class ShaderData
{

	// Default attributes are names aVertexPosition, aVertexData, aVertexUV
	// Default uniforms are uViewMatrix and uProjectionMatrix
	// Textures are stored in uniforms named uTexture0-32
	
	
	public var usesColor : Bool = false;
	public var numTextures : Int = 0;
	
	public function new() 
	{
		
	}
	
	public function getGLSL() : String {
		return "";
	}
	
	public function getAGAL() : String {
		return "";
	}
	
}