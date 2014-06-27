package uk.co.mojaworks.frameworkv2.renderer;

import flash.display.BitmapData;
import openfl.Assets;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.Int32Array;
import openfl.utils.UInt8Array;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

/**
 * ...
 * @author Simon
 */
class GLTextureManager extends CoreObject
{

	private var _textures : Map<String, TextureData>;
	
	public function new() 
	{
		super();
		
		_textures = new Map<String, TextureData>();
	}
	
	public function loadTexture( assetId : String, sheetData : String ) {
		
		var t_data : TextureData = new TextureData();
		t_data.id = assetId;
		t_data.sourceBitmap = Assets.getBitmapData( assetId );
		t_data.texture = GL.createTexture();
		
		// Create the texture
		GL.bindTexture( GL.TEXTURE_2D, texture );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE );
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, bitmap.width, bitmap.height, 0, GL.RGBA, new UInt8Array(bitmap.getPixels( bitmap.rect ) ) );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
		GL.bindTexture( GL.TEXTURE_2D, null );	
		
		// Save it for future use
		_textures.set( assetId, t_data );
		
	}
	
	public function getTexture( id : String ) : TextureData {
		return _textures.get( id );
	}
	
	public function getSpriteRect() : Void {
		
	}
	
}