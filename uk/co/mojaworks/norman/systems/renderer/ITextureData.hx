package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.Image;
import lime.math.Rectangle;

/**
 * ...
 * @author Simon
 */
interface ITextureData
{
	public var id : String;
	public var sourceImage : Image;
	public var map : Dynamic; // Interpreted JSON object
	public var useCount : Int;
	public var isValid : Bool;
	public var width( get, never ) : Float;
	public var height( get, never ) : Float;
		
	function getRectFor( subImageId : String ) : Rectangle;
	function getUVFor( subImageId : String ) : Rectangle;
}