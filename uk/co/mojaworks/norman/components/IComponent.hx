package uk.co.mojaworks.norman.components;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.IDisposable;

/**
 * @author Simon
 */
interface IComponent extends IDisposable
{
	public var enabled( default, set ) : Bool;
	public var gameObject : GameObject;
	public var destroyed : Bool;
	
	public function destroy() : Void;
	
	public function onAdded() : Void;
	
	public function onRemove() : Void;
	public function isEnabled() : Bool;
	
	private function set_enabled( bool : Bool ) : Bool;
	
	public function is( type : String ) : Bool;
}