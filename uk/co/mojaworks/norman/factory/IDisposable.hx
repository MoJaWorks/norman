package uk.co.mojaworks.norman.factory;

/**
 * @author Simon
 */
interface IDisposable 
{
	public var destroyed : Bool;
	public function destroy() : Void;
}