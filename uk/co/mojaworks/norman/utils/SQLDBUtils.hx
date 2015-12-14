package uk.co.mojaworks.norman.utils;
import uk.co.mojaworks.norman.db.SQLiteDB.SQLDBResult;

/**
 * ...
 * @author Simon
 */
class SQLDBUtils
{

	public function new() 
	{
		
	}
	
	public static function toStringArray( results : Array<SQLDBResult>, columnName : String ) : Array<String>
	{
		var returnData : Array<String> = [];
		
		if ( results.length > 0 ) 
		{
			for ( result in results ) 
			{
				returnData.push( result.get( columnName ) );
			}
		}
		
		return returnData;
		
	}
	
	public static function toIntArray( results : Array<SQLDBResult>, columnName : String ) : Array<Int>
	{
		var returnData : Array<Int> = [];
		
		if ( results.length > 0 ) 
		{
			for ( result in results ) 
			{
				returnData.push( Std.parseInt( result.get( columnName ) ) );
			}
		}
		
		return returnData;
		
	}
	
	public static function toFloatArray( results : Array<SQLDBResult>, columnName : String ) : Array<Float>
	{
		var returnData : Array<Float> = [];
		
		if ( results.length > 0 ) 
		{
			for ( result in results ) 
			{
				returnData.push( Std.parseFloat( result.get( columnName ) ) );
			}
		}
		
		return returnData;
		
	}
	
}