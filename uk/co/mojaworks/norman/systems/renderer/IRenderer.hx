package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.Image;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;

/**
 * @author Simon
 */

interface IRenderer 
{
	// Textures
	function createTexture( id : String, width : Int, height : Int ) : ITextureData;
	function createTextureFromImage( id : String, src : Image, map : String = null ) : ITextureData;
	function createTextureFromAsset( id : String ) : ITextureData;
	function hasTexture( id : String ) : Bool;
	function getTexture( id : String ) : ITextureData;
	function destroyTexture( id : String ) : Void;
	function reviveTexture( texture:ITextureData ) : Void;
	
	// Shaders
	function createShader( vertexShader : ShaderData, fragmentData : ShaderData ) : IShaderProgram;
	
	// Canvas
	function getCanvas() : ICanvas;
	function resize( width : Int, height : Int ) : Void;
	function render( root : GameObject ) : Void;
	
	
	
}