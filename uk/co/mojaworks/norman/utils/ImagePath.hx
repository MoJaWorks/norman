package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
abstract ImageAssetPath(String) to String from String
{

	public var asset( get, never ) : String;
	public var subImageId( get, never ) : String;
	
	private function get_asset( ) : String 
	{
		return this.split(":")[0];
	}
	
	private function get_subImageId( ) : String 
	{
		var temp : Array<String> = this.split(":");
		if ( temp.length > 1 )
			return temp[1];
			
		return null;
	}
	
}