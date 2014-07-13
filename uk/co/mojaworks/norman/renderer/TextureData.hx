package uk.co.mojaworks.norman.renderer;
import flash.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Simon
 */
class TextureData
{

	// The source bitmap and an ID used to keep track of it
	public var sourceBitmap : BitmapData;
	public var id : String;
	
	#if (!flash)
		public var texture : openfl.gl.GLTexture;
	#else
		public var texture : flash.display3D.textures.Texture;
	#end
	
	// This will be a parsed JSON object
	public var spriteMap : Dynamic;
	
	public function new() 
	{
		
	}
	
	public function getRectFor( subImageId : String ) : Rectangle {
		
		var result : Rectangle = null;
		if ( spriteMap != null ) {
			var img : Dynamic = Reflect.field( spriteMap.frames, subImageId );
			if ( img != null ) {
				result = new Rectangle( img.spriteSourceSize.x, img.spriteSourceSize.y, img.sourceSize.w, img.sourceSize.h );
			}else {
				trace("No subimage " + subImageId + " in texture " + id );
			}
		}
		
		return result;
		
	}
	
	public function getUVFor( subImageId : String ) : Rectangle {
		
		var result : Rectangle = null;
		if ( spriteMap != null ) {
			var img : Dynamic = Reflect.field( spriteMap.frames, subImageId );
			if ( img != null ) {
				result = new Rectangle( 
					img.frame.x / sourceBitmap.width,
					img.frame.y / sourceBitmap.height,
					img.frame.w / sourceBitmap.width,
					img.frame.h / sourceBitmap.height
				);
			}else {
				trace("No subimage " + subImageId + " in texture " + id );
			}
		}
		
		return result;
	}
	
}