package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.Image;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * @author Simon
 */

interface IRenderer 
{
	// Textures
	function createTexture( id : String, width : Int, height : Int ) : TextureData;
	function createTextureFromImage( id : String, src : Image, map : String = null ) : TextureData;
	function createTextureFromAsset( id : String ) : TextureData;
	function hasTexture( id : String ) : Bool;
	function getTexture( id : String ) : TextureData;
	function destroyTexture( id : String ) : Void;
	
	// Shaders
	function createShader( vertexShader : ShaderData, fragmentData : ShaderData ) : IShaderProgram;
	
	// Canvas
	function getCanvas() : ICanvas;
	function resize( width : Int, height : Int ) : Void;
	function render( root : GameObject ) : Void;
	
	
}