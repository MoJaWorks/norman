package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.Image;

/**
 * ...
 * @author Simon
 */
interface ITextureManager
{
	function createTexture( id : String, image : Image, map : String = null ) : TextureData;	
}