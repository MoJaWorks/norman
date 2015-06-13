package uk.co.mojaworks.norman.text;
import uk.co.mojaworks.norman.systems.renderer.TextureData;

/**
 * ...
 * @author Simon
 */

class CharacterData {
	
	public var id : Int;
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	public var xOffset : Int;
	public var yOffset : Int;
	public var xAdvance : Int;
	public var pageId : Int;
	public function new( id : Int = 0 ) {
		this.id = id;
	};
	
}

class KerningData {
	public var first : Int;
	public var second : Int;
	public var amount : Int;
	public function new() { };
}
 
class BitmapFont
{
	public var id : String;
	public var face : String;
	public var size : Int;
	public var bold : Bool;
	public var italic : Bool;
	public var padding : Array<Int>;
	public var spacing : Array<Int>;
	public var lineHeight : Int;
	public var base : Int;
	public var numPages : Int;
	public var pages : Array<TextureData>;
	public var characters : Map<Int,CharacterData>;
	public var kernings : Map<Int,Map<Int,KerningData>>;
		
	public function new() {
		padding = [];
		spacing = [];
		characters = new Map<Int,CharacterData>();
		kernings = new Map<Int, Map<Int,KerningData> >();
		pages = [];
	}
}