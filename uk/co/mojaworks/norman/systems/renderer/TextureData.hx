package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;
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
	public var isValid : Bool = true;
	public var texture : GLTexture;
	public var width( get, never ) : Float;
	public var height( get, never ) : Float;
	
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
				result = new Rectangle( 0, 0, sourceImage.width, sourceImage.height );
			}
		}
		
		return result;
		
	}
	
	public function getUVFor( subImageId : String ) : Rectangle {
		
		//trace("Looking for uv rect", subImageId, map );
		
		var result : Rectangle = null;
		if ( subImageId == null ) {
			result = new Rectangle( 0, 0, 1, 1 );
			
		}else if ( map != null ) {
			
			var img : Dynamic = Reflect.field( map.frames, subImageId );
			if ( img != null ) {
				result = new Rectangle( 
					(img.frame.x / sourceImage.width),
					(img.frame.y / sourceImage.height),
					(img.frame.w / sourceImage.width),
					(img.frame.h / sourceImage.height)
				);
			}else {
				trace("No subimage " + subImageId + " in texture " + id );
				result = new Rectangle( 0, 0, 1, 1 );
			}
		}
		
		return result;
	}
	
	private function get_width() : Float {
		return sourceImage.width;
	}
	
	private function get_height() : Float {
		return sourceImage.height;
	}
}