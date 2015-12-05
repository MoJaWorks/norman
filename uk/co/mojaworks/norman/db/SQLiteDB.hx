package uk.co.mojaworks.norman.db;
import sys.db.Connection;
import sys.db.ResultSet;
import sys.db.Sqlite;

#if android
	// Make SQLite work on android by statically compiling the library
	import hxcpp.StaticSqlite;
#end

/**
 * ...
 * @author Simon
 */
class SQLiteDB
{
	
	private var _dbConnection : Connection;

	public function new( filename : String ) 
	{
		_dbConnection = Sqlite.open( filename );
	}
	
	public function close() : Void 
	{
		_dbConnection.close();
		_dbConnection = null;
	}
	
	/**
	 * 
	 */
	
	public function query( sql : String ) : ResultSet 
	{
		trace("Running SQL Query: \"" + sql + "\"");
		return _dbConnection.request( sql );
	}
	
	/**
	 * 
	 * 
	 */
	
	public function select( fields : Array<String>, from : String, where : String = "", whereVars : Array<Dynamic> = null, orderBy : String = "", limit : String = "" ) : Array<Map<String,String>>
	{
		var action : String = "SELECT " + fields.join(",") + " FROM " + from;
		var sql : String = buildQuery( action, where, whereVars, orderBy, limit );
		
		var results : ResultSet = query( sql );
		var returnData : Array<Map<String,String>> = [];
		
		for ( result in results ) {
			
			var returnRow : Map<String,String> = new Map<String,String>();
			
			for ( field in fields ) {
				returnRow.set( field, Reflect.getProperty( result, field ) );
			}
			
			returnData.push( returnRow );
			
		}
		
		return returnData;
		
	}
	
		
	public function selectSingle( fields : Array<String>, from : String, where : String = "", whereVars : Array<Dynamic> = null, orderBy : String = "" ) : Map<String,String>
	{
		var result : Array<Map<String,String>> = select( fields, from, where, whereVars, orderBy, "1" );
		if ( result.length > 0 ) {
			return result[0];
		}else {
			return null;
		}
	}
	
	/**
	 * 
	 * 
	 */
	
	public function update( table : String, values : Map<String,Dynamic>, where : String = "", whereVars : Array<Dynamic> = null ) : Void
	{
		var action : String = "UPDATE " + table + " SET ";
		
		var first : Bool = true;
		
		for ( key in values.keys() ) {
			
			if ( first ) first = false;
			else action += ", ";
			
			action += key + "=" + convertToDatabaseValue( values.get( key ) );
		}
		
		var sql : String = buildQuery( action, where, whereVars );
		
		query( sql );
		
	}
	
	/**
	 *
	 * 
	 */
	
	public function insert( table : String, values : Map<String,Dynamic> ) : Int
	{
		var sql : String = "INSERT INTO " + table + " (";
		var first : Bool = true;
		
		for ( key in values.keys() ) {
			
			if ( first ) first = false;
			else sql += ", ";
			
			sql += key;
		}
		
		sql += ") VALUES (";
				
		first = true;
		for ( key in values.keys() ) {
			
			if ( first ) first = false;
			else sql += ", ";
			
			sql += convertToDatabaseValue( values.get( key ) );
		}
		
		sql += ";";
		
		query( sql );
		
		return _dbConnection.lastInsertId();
		
	}
	
	/**
	 * 
	 * 
	 */
	
	public function convertToDatabaseValue( item : Dynamic ) : String 
	{
		if ( Std.is( item, Bool ) ) 
		{
			return item ? "1" : "0";
		}
		else if ( Std.is( item, String ) ) 
		{
			
			var strItem : String = cast item;
			
			var constants : Array<String> = ["CURRENT_TIME", "CURRENT_TIMESTAMP", "CURRENT_DATE"];
			if ( constants.indexOf( strItem ) > -1 ) return strItem;
			
			var isFunction : Bool = (strItem.indexOf( "(" ) > -1);
			if ( isFunction ) return strItem;
			else return _dbConnection.quote( strItem );
			
		}
		else 
		{
			return Std.string( item );
		}
	}
	
	
	public function generateStringFromFormat( format : String, vars : Array<Dynamic> ) : String
	{
		var regex : EReg = ~/:([0-9]+)/g;
		var result : String = regex.map( format, function ( reg : EReg ) : String {
			return convertToDatabaseValue( vars[ Std.parseInt( reg.matched( 1 ) ) ] );
		});
		
		return result;
	}
	
	
	/**
	 * 
	 */
	
	private function buildQuery( action : String, where : String = "", whereVars : Array<Dynamic> = null, orderBy : String = "", limit : String = "" ) : String 
	{
		var sql : String = action;
				
		// Replace the where vars
		if ( where != "" ) 
		{
			if ( whereVars != null ) 
			{
				where = generateStringFromFormat( where, whereVars );				
			}
			
			sql += " WHERE " + where;
		}
		
		if ( orderBy != "" ) sql += " ORDER BY " + orderBy;
		if ( limit != "" ) sql += " LIMIT " + limit;
		sql += ";";
			
		return sql;
	}
	
	
	public function getLastInsertId() : Int {
		return _dbConnection.lastInsertId();
	}
	
	public function attach( filename : String, dbname : String ) : Void
	{
		query( "ATTACH DATABASE '" + filename + "' AS " + dbname + ";" );
	}
	
}