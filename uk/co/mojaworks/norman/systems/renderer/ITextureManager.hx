package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.Image;

/**
 * ...
 * @author Simon
 */
interface ITextureManager
{
	function createTexture( id : String, width : Int, height : Int ) : TextureData;
	function createTextureFromImage( id : String, image : Image, map : String = null ) : TextureData;
	function hasTexture( id : String ) : Bool;
	function getTexture( id : String ) : TextureData;
	function removeTexture( id : String ) : Void;
}