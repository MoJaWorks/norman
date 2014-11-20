package uk.co.mojaworks.norman.components.display.text.font ;

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
	public function new() { };
	
}

class KerningData {
	public var first : Int;
	public var second : Int;
	public var amount : Int;
	public function new() { };
}
 
class FontData
{
	
	public var face : String;
	public var size : Int;
	public var bold : Bool;
	public var italic : Bool;
	public var padding : Array<Int>;
	public var spacing : Array<Int>;
	public var lineHeight : Int;
	public var base : Int;
	public var pageFilenames : Array<String>;
	public var characters : Array<CharacterData>;
	public var kernings : Array<KerningData>;
		
	public function new() {
		padding = [];
		spacing = [];
		pageFilenames = [];
		characters = [];
		kernings = [];
	}
}