package uk.co.mojaworks.frameworkv2.renderer ;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.renderer.TextureData;

/**
 * @author Simon
 */

class TextureManager extends Component
{
  
	private var _textures : Map<String, TextureData>;
	
	public function new() {
		super();
		_textures = new Map<String, TextureData>();
	}
	
	public function loadTexture( assetId : String ) : Void {
		  
	}
	  
	public function getTexture ( id : String ) : TextureData {
		return _textures.get(id);
	};
	
	public function hasTexture(textureId:String) 
	{
		return _textures.get( textureId );
	}
}