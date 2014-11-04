package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.Image;
import lime.math.Rectangle;

/**
 * ...
 * @author Simon
 */
class TextureData
{
	public var id : String;
	public var sourceImage : Image;
	public var map : Dynamic; // Interpreted JSON object
	public var useCount : Int = 0;
	
	public function new() {
		
	}
	
	public function getRectFor( subImageId : String ) : Rectangle {
		
		var result : Rectangle = null;
		
		if ( subImageId == null ) {
			result = new Rectangle( 0, 0, sourceImage.width, sourceImage.height );
		}else if ( map != null ) {
			var img : Dynamic = Reflect.field( map.frames, subImageId );
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
			//result = new Rectangle( 0, 0, paddingMultiplierX, paddingMultiplierY );
			result = new Rectangle( 0, 0, 1, 1 );
			
		}else if ( map != null ) {
			var img : Dynamic = Reflect.field( map.frames, subImageId );
			if ( img != null ) {
				result = new Rectangle( 
					//(img.frame.x / sourceBitmap.width) * paddingMultiplierX,
					//(img.frame.y / sourceBitmap.height) * paddingMultiplierY,
					//(img.frame.w / sourceBitmap.width) * paddingMultiplierX,
					//(img.frame.h / sourceBitmap.height) * paddingMultiplierY
					(img.frame.x / sourceImage.width),
					(img.frame.y / sourceImage.height),
					(img.frame.w / sourceImage.width),
					(img.frame.h / sourceImage.height)
				);
			}else {
				trace("No subimage " + subImageId + " in texture " + id );
			}
		}
		
		return result;
	}
}