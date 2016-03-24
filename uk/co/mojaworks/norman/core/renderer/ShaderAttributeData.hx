package uk.co.mojaworks.norman.core.renderer;

/**
 * ...
 * @author Simon
 */
class ShaderAttributeData
{

	public var size : Int;
	public var start : Int;
	public var name : String;
	
	public function new( name : String, start : Int, size : Int ) 
	{
		this.name = name;
		this.start = start;
		this.size = size;
	}
	
}