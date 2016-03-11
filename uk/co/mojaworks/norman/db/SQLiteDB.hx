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

typedef SQLDBResult = Map<String,String>;
 
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
	
	public function queryResult( sql : String ) : Array<SQLDBResult>
	{
		trace("Running SQL Query: \"" + sql + "\"");
		
		var resultSet : ResultSet = _dbConnection.request( sql );
		var returnData : Array<SQLDBResult> = [];
		
		for ( result in resultSet ) {
			
			var returnRow : SQLDBResult = new SQLDBResult();
			var resultFields : Array<String> = Reflect.fields( result );
			
			for ( field in resultFields ) {
				var resultField : Dynamic = Reflect.getProperty( result, field );
				if ( resultField != null ) {
					returnRow.set( field, Std.string( resultField ) );
				}else {
					returnRow.set( field, null );
				}
			}
			
			returnData.push( returnRow );
			
		}
		
		return returnData;
	}
	
	
	public function query( sql : String ) : Void
	{
		
		trace("Running SQL Query: \"" + sql + "\"");
		_dbConnection.request( sql );
		
	}
	
	/**
	 * 
	 * 
	 */
	
	public function select( fields : Array<String>, from : String, where : String = "", whereVars : Array<Dynamic> = null, orderBy : String = "", limit : String = "" ) : Array<SQLDBResult>
	{
		var action : String = "SELECT " + fields.join(",") + " FROM " + from;
		var sql : String = buildQuery( action, where, whereVars, orderBy, limit );
		
		return queryResult( sql );
		
	}
	
		
	public function selectSingle( fields : Array<String>, from : String, where : String = "", whereVars : Array<Dynamic> = null, orderBy : String = "" ) : SQLDBResult
	{
		var result : Array<Map<String,String>> = select( fields, from, where, whereVars, orderBy, "1" );
		if ( result.length > 0 ) {
			return result[0];
		}else {
			return null;
		}
	}
	
	public function count( from : String, where : String, whereVars : String ) : Int 
	{
		var result : SQLDBResult = selectSingle( ["count(*) as count"], from, where, whereVars );
		return Std.parseInt(result.get("count"));
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
			
			action += key + "=" + prepare( values.get( key ) );
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
			
			sql += prepare( values.get( key ) );
		}
		
		sql += ");";
		
		query( sql );
		
		return getLastInsertId();
		
	}
	
	/**
	 * 
	 */
	
	public function delete( table : String, where : String = "", whereVars : Array<Dynamic> = null ) : Void
	{
		var action : String = "DELETE FROM " + table;
		var sql : String = buildQuery( action, where, whereVars );
		
		query( sql );
	}
	
	/**
	 * 
	 * 
	 */
	
	public function prepare( item : Dynamic ) : String 
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
			return prepare( vars[ Std.parseInt( reg.matched( 1 ) ) ] );
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