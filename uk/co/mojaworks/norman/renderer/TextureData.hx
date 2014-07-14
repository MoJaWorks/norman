package uk.co.mojaworks.norman.renderer;
import flash.display.BitmapData;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class TextureData
{

	// The source bitmap and an ID used to keep track of it
	public var sourceBitmap( default, set ) : BitmapData;
	public var id : String;
	
	#if (!flash)
		public var texture : openfl.gl.GLTexture;
	#else
		public var texture : flash.display3D.textures.Texture;
	#end
	
	// This will be a parsed JSON object
	public var spriteMap : Dynamic;
	
	public var paddingMultiplierX : Float = 1;
	public var paddingMultiplierY : Float = 1;
	
	public function new() 
	{
		
	}
	
	public function getRectFor( subImageId : String ) : Rectangle {
		
		var result : Rectangle = null;
		
		if ( subImageId == null ) {
			result = new Rectangle( 0, 0, sourceBitmap.width, sourceBitmap.height );
		}else if ( spriteMap != null ) {
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
		if ( subImageId == null ) {
			result = new Rectangle( 0, 0, paddingMultiplierX, paddingMultiplierY );
		}else if ( spriteMap != null ) {
			var img : Dynamic = Reflect.field( spriteMap.frames, subImageId );
			if ( img != null ) {
				result = new Rectangle( 
					(img.frame.x / sourceBitmap.width) * paddingMultiplierX,
					(img.frame.y / sourceBitmap.height) * paddingMultiplierY,
					(img.frame.w / sourceBitmap.width) * paddingMultiplierX,
					(img.frame.h / sourceBitmap.height) * paddingMultiplierY
				);
			}else {
				trace("No subimage " + subImageId + " in texture " + id );
			}
		}
		
		return result;
	}
	
	private function set_sourceBitmap( bitmap : BitmapData ) : BitmapData {
		this.sourceBitmap = bitmap;
		
		#if ( flash ) 
			paddingMultiplierX = sourceBitmap.width / MathUtils.roundToNextPow2( sourceBitmap.width );
			paddingMultiplierY = sourceBitmap.height / MathUtils.roundToNextPow2( sourceBitmap.height );
			
			trace("Setting padding to", paddingMultiplierX, paddingMultiplierY, MathUtils.roundToNextPow2( sourceBitmap.width ) );
		#end
		
		return bitmap;
	}
	
}