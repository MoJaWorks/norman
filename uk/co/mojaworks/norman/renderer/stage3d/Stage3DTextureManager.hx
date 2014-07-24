package uk.co.mojaworks.norman.renderer.stage3d;

import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import uk.co.mojaworks.norman.renderer.TextureManager;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class Stage3DTextureManager extends TextureManager
{

	var _context : Context3D = null;
	
	public function new() 
	{
		super();
		
	}
	
	public function setContext( context : Context3D ) : Void {
		_context = context;
	}
	
	override public function loadTexture( assetId : String ) : TextureData {
		
		// Let super do its thing and build a texturedata
		var t_data : TextureData = super.loadTexture( assetId );		
		
		if ( _context != null ) {
			createStage3DTexture( t_data );
		}
		
		return t_data;
		
	}
	
	public function createStage3DTexture( t_data : TextureData ) : Void {
		// Create the Stage3D texture
		t_data.texture = _context.createTexture( MathUtils.roundToNextPow2( t_data.sourceBitmap.width ), MathUtils.roundToNextPow2( t_data.sourceBitmap.height ), Context3DTextureFormat.BGRA, false );
		t_data.texture.uploadFromBitmapData( t_data.sourceBitmap, 0 );
	}
		
	override public function restoreTextures() 
	{		
		for ( key in _textures.keys() ) {
			createStage3DTexture( _textures.get(key) );
		}
	}
	
}