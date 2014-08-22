package uk.co.mojaworks.norman.renderer.gl ;

import openfl.gl.GL;
import openfl.utils.UInt8Array;
import uk.co.mojaworks.norman.renderer.TextureData;

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
	
	override public function loadTexture( assetId : String ) : TextureData {
		
		// Let super do its thing and build a texturedata
		var t_data : TextureData = super.loadTexture( assetId );		
		createGLTexture( t_data );
		return t_data;
		
	}
	
	override public function loadBitmap(id:String, bitmap:BitmapData):TextureData 
	{
		var t_data : TextureData = super.loadBitmap(id, bitmap);
		createGLTexture( t_data );
		return t_data;
	}
	
	public function createGLTexture( t_data : TextureData ) : Void {
		// Create the GL texture
		
		t_data.texture = GL.createTexture();
		GL.bindTexture( GL.TEXTURE_2D, t_data.texture );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE );
		#if html5
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, t_data.sourceBitmap.width, t_data.sourceBitmap.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, t_data.sourceBitmap.getPixels( t_data.sourceBitmap.rect ).byteView );
		#else
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, t_data.sourceBitmap.width, t_data.sourceBitmap.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, new UInt8Array(t_data.sourceBitmap.getPixels( t_data.sourceBitmap.rect ) ) );
		#end
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
		GL.bindTexture( GL.TEXTURE_2D, null );
	}
		
	override public function restoreTextures() 
	{
		for ( key in _textures.keys() ) {
			createGLTexture( _textures.get(key) );
		}
	}
	
	override public function unloadTexture( id : String ) : Void  
	{
		GL.deleteTexture( _textures.get(id).texture );
	}
		
}