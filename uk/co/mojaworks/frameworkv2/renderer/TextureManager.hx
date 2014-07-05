package uk.co.mojaworks.frameworkv2.renderer ;
import haxe.Json;
import openfl.Assets;
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
	
	public function loadTexture( assetId : String ) : TextureData {
		
		var t_data : TextureData = new TextureData();
		t_data.id = assetId;
		t_data.sourceBitmap = Assets.getBitmapData( assetId );
		
		if ( Assets.exists( assetId + ".map" ) ) {
			t_data.spriteMap = Json.parse( Assets.getText(assetId + ".map") );
		}
		
		// Save it for future use
		_textures.set( assetId, t_data );
		return t_data;
	}
	  
	public function getTexture ( id : String ) : TextureData {
		return _textures.get(id);
	};
	
	public function hasTexture( id : String ) : Bool
	{
		return _textures.get( id ) != null;
	}
}