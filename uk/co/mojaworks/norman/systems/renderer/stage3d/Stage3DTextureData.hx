package uk.co.mojaworks.norman.systems.renderer.stage3d;
import flash.display3D.textures.Texture;
import lime.graphics.Image;
import lime.math.Rectangle;

/**
 * ...
 * @author ...
 */
class Stage3DTextureData implements ITextureData
{

	public var id : String;
	public var sourceImage : Image;
	public var map : Dynamic; // Interpreted JSON object
	public var useCount : Int = 0;
	public var isValid : Bool = true;
	public var texture : Texture;
	public var xPerc : Float = 1;
	public var yPerc : Float = 1;
	public var width( get, never ) : Float;
	public var height( get, never ) : Float;
	
	public function new() {
		
	}
	
	public function getRectFor( subImageId : String ) : Rectangle {
		
		var result : Rectangle = null;
		
		if ( subImageId == null ) {
			result = new Rectangle( 0, 0, sourceImage.width * xPerc, sourceImage.height * yPerc );
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
			result = new Rectangle( 0, 0, xPerc, yPerc );
			
		}else if ( map != null ) {
			var img : Dynamic = Reflect.field( map.frames, subImageId );
			if ( img != null ) {
				result = new Rectangle( 
					(img.frame.x * xPerc / sourceImage.width),
					(img.frame.y * yPerc / sourceImage.height),
					(img.frame.w * xPerc / sourceImage.width),
					(img.frame.h * yPerc / sourceImage.height)
				);
			}else {
				trace("No subimage " + subImageId + " in texture " + id );
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