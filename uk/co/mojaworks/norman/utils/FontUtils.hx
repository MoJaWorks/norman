package uk.co.mojaworks.norman.utils;
import haxe.xml.Fast;
import lime.Assets;
import uk.co.mojaworks.norman.components.display.text.BitmapFont;
import uk.co.mojaworks.norman.core.Core;

/**
 * ...
 * @author Simon
 */
class FontUtils
{
	
	public function new() 
	{
		
	}
	
	public static function createFontFromFnt( id : String ) : BitmapFont {
		
		var fast : Fast = new Fast( Xml.parse( Assets.getText(id) ).firstElement() );
		
		var data : BitmapFont = new BitmapFont();
		data.id = id;
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
		
		data.numPages = fast.node.pages.nodes.page.length;
		
		var page_root : String = id.substring(0, id.lastIndexOf("/") );
		trace("Font root is", page_root);
		for ( page in fast.node.pages.nodes.page ) {
			data.pages.push( Core.getInstance().app.renderer.createTextureFromAsset( page_root + "/" + page.att.file ) );
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
			data.characters.set( char_data.id, char_data );
			
		}
		
		for ( kern in fast.node.kernings.nodes.kerning ) {
			
			var kern_data : KerningData = new KerningData();
			kern_data.first = Std.parseInt( kern.att.first );
			kern_data.second = Std.parseInt( kern.att.second );
			kern_data.amount = Std.parseInt( kern.att.amount );
			if ( data.kernings.get( kern_data.first ) == null ) data.kernings.set( kern_data.first, new Map<Int, KerningData>() );
			data.kernings.get( kern_data.first ).set( kern_data.second, kern_data ) ;
		}
		
		return data;
		
	}
	
}