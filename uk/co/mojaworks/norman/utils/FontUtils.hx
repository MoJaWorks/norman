package uk.co.mojaworks.norman.utils;
import haxe.xml.Fast;
import uk.co.mojaworks.norman.components.display.text.font.FontData;

/**
 * ...
 * @author Simon
 */
class FontUtils
{
	
	public function new() 
	{
		
	}
	
	public static function parseFnt( file : String ) : FontData {
		
		var fast : Fast = new Fast( Xml.parse( file ).firstElement() );
		
		var data : FontData = new FontData();
		data.face = fast.node.info.att.face;
		data.size = Std.int(Math.abs( Std.parseInt( fast.node.info.att.size ) ));
		data.bold = fast.node.info.att.bold == "1";
		data.italic = fast.node.info.att.italic == "1";
		
		for ( v in fast.node.info.att.padding.split(",") ) {
			data.padding.push( Std.parseInt( v ) );
		}
		
		for ( v in fast.node.info.att.spacing.split(",") ) {
			data.spacing.push( Std.parseInt( v ) );
		}
		
		data.lineHeight = Std.parseInt(fast.node.common.att.lineHeight);
		data.base = Std.parseInt(fast.node.common.att.base);
		
		for ( page in fast.node.pages.nodes.page ) {
			data.pageFilenames.push( page.att.file );
		}
		
		for ( char in fast.node.chars.nodes.char ) {
			
			var char_data : CharacterData = new CharacterData();
			char_data.id = Std.parseInt( char.att.id );
			char_data.x = Std.parseInt( char.att.x );
			char_data.y = Std.parseInt( char.att.y );
			char_data.width = Std.parseInt( char.att.width );
			char_data.height = Std.parseInt( char.att.height );
			char_data.xOffset = Std.parseInt( char.att.xoffset );
			char_data.yOffset = Std.parseInt( char.att.yoffset );
			char_data.xAdvance = Std.parseInt( char.att.xadvance );
			char_data.pageId = Std.parseInt( char.att.page );
			data.characters.push( char_data );
			
		}
		
		for ( kern in fast.node.kernings.nodes.kerning ) {
			
			var kern_data : KerningData = new KerningData();
			kern_data.first = Std.parseInt( kern.att.first );
			kern_data.second = Std.parseInt( kern.att.second );
			kern_data.amount = Std.parseInt( kern.att.amount );
			data.kernings.push( kern_data );
		}
		
		return data;
		
	}
	
}