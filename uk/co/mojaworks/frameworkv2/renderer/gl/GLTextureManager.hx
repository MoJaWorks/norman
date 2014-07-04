package uk.co.mojaworks.frameworkv2.renderer.gl ;

import flash.display.BitmapData;
import haxe.Json;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.Int32Array;
import openfl.utils.UInt8Array;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.renderer.TextureData;

/**
 * ...
 * @author Simon
 */
class GLTextureManager extends TextureManager
{
	
	
	public function new() 
	{
		super();
		
		
	}
	
	override public function loadTexture( assetId : String ) : Void {
		
		var t_data : TextureData = new TextureData();
		t_data.id = assetId;
		t_data.sourceBitmap = Assets.getBitmapData( assetId );
		t_data.spriteMap = Json.parse( Assets.getText(assetId + ".map") );
		t_data.glTexture = GL.createTexture();
		
		// Create the texture
		GL.bindTexture( GL.TEXTURE_2D, t_data.glTexture );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE );
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, t_data.sourceBitmap.width, t_data.sourceBitmap.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, new UInt8Array(t_data.sourceBitmap.getPixels( t_data.sourceBitmap.rect ) ) );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
		GL.bindTexture( GL.TEXTURE_2D, null );	
		
		// Save it for future use
		_textures.set( assetId, t_data );
		
	}
	
	override public function getTexture( id : String ) : TextureData {
		return _textures.get( id );
	}
		
}