package uk.co.mojaworks.norman.model;

import haxe.ds.StringMap;
import lime.Assets;
import lime.system.System;
import lime.utils.Bytes;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
import uk.co.mojaworks.norman.db.SQLiteDB;
import uk.co.mojaworks.norman.core.model.Proxy;

/**
 * ...
 * @author Simon
 */
class DatabaseProxy extends Proxy
{
	static public inline var ID:String = "DatabaseProxy";
	
	public var db:SQLiteDB;

	public function new( asset : String ) 
	{
		super( ID );
		
		var filename : String = copyDBToLocal( asset, "main", true );
		db = new SQLiteDB( filename );
		
	}
	
	private function copyDBToLocal( asset : String, dbName : String, overwriteIfExists : Bool ) : String 
	{
		var filename : String = System.applicationStorageDirectory + dbName + ".db";
		
		if ( overwriteIfExists || !FileSystem.exists( filename ) ) {
			var dbGame : Bytes = Assets.getBytes( asset );
			var file : FileOutput = File.write( filename, true );
			file.writeBytes( dbGame, 0, dbGame.length );
			file.close();
		}
		
		return filename;
	}
	
	public function addDBFile( asset : String, overwriteIfExists : Bool, dbName : String ) : Void 
	{
		var filename : String = copyDBToLocal( asset, dbName, overwriteIfExists );
		db.attach( filename, dbName );
	}
	
}