package uk.co.mojaworks.norman.components.renderer ;
import flash.display.BitmapData;
import haxe.Json;
import openfl.Assets;
import uk.co.mojaworks.norman.core.Component;

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
	
	public function loadBitmap( id : String, bitmap : BitmapData ) : TextureData {
		
		var t_data : TextureData = new TextureData();
		t_data.id = id;
		t_data.sourceBitmap = bitmap;
		
		if ( _textures.get( id ) != null ) {
			unloadTexture( id );
		}
		
		_textures.set( id, t_data );
		return t_data;
		
	}
	  
	public function getTexture ( id : String ) : TextureData {
		return _textures.get(id);
	};
	
	public function hasTexture( id : String ) : Bool
	{
		return _textures.get( id ) != null;
	}
	
	public function restoreTextures() 
	{
		// Override
	}
	
	public function unloadTexture( id : String ) : Void  
	{
		// Override
	}
}