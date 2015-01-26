package uk.co.mojaworks.norman.components.display;

/**
 * ...
 * @author ...
 */
class ImageAssetSprite extends ImageSprite
{

	public function new() 
	{
		super();
	}
	
	public function setTextureId( textureId : String, subTextureId : String = null ) : ImageAssetSprite {
	
		if ( core.app.renderer.hasTexture( textureId ) ) {
			setTexture( core.app.renderer.getTexture( textureId ), subTextureId );
		}else {
			setTexture( core.app.renderer.createTextureFromAsset( textureId ), subTextureId );
		}
		
		return this;
	}
	
}