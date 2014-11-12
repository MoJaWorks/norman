package uk.co.mojaworks.norman.systems.renderer.shaders ;
import lime.graphics.RenderContext;

/**
 * ...
 * @author Simon
 */
interface IShaderProgram
{
	public function compile( ) : Void;
	
	// If it uses color then it must define an aVertexColor attribute
	public function getUsesColor( ) : Bool;
	
	// It is uses textures then it must define an aTexture0 - aTexture32 attribute depending on the number of textures required
	public function getNumTextures( ) : Int;
}