package uk.co.mojaworks.norman.components.display.text.font ;
import lime.Assets;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.FontUtils;

/**
 * ...
 * @author Simon
 */
class BitmapFont
{
	
	var _data : FontData;
	var textures : Array<TextureData>;

	// Provide the bitmap font with an asset id for the .fnt file minus the extension
	public function new( id : String ) 
	{
		_data = FontUtils.parseFnt( Assets.getText( id + ".fnt" ) );
		_textures = [];
		
		
	}
	
}