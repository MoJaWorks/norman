package uk.co.mojaworks.norman.resource;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;

/**
 * ...
 * @author Simon
 */

class ResourcesBuilder
{

	public static function getDirectoryListing( dir : String, ?names : Map<String,String> = null ) : Map<String,String> 
	{
		
		if ( names == null ) names = new Map<String,String>();
		
		var files = FileSystem.readDirectory( dir );
		
		for ( file in files ) 
		{			
			if ( FileSystem.isDirectory( dir + "/" + file ) ) 
			{
				getDirectoryListing( dir + "/" + file, names );
			}
			else
			{
				var sanitised : String = StringTools.replace( dir + "/" + file.toUpperCase(), ".", "" );
				sanitised = StringTools.replace( sanitised, "/", "_" );
				sanitised = StringTools.replace( sanitised, "-", "_" );
				sanitised = sanitised.substring( 7 );
				names.set( sanitised, dir + "/" + file );
			}
		}
		
		return names;
	}
	
	public static macro function build( ) : Array<Field>
	{
		var fields : Array<Field> = Context.getBuildFields();
		var listing = getDirectoryListing( "assets" );
			
		//trace( listing );
		
		for ( file in listing.keys() ) 
		{
			fields.push( {
				name: file,
				pos: Context.currentPos(),
				kind: FVar(macro : String, Context.makeExpr( listing.get( file ), Context.currentPos() ) ),
				access: [APublic, AStatic]
			} );
		}
		
		return fields;
		
	}
	
}