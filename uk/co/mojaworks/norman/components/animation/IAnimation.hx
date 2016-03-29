package uk.co.mojaworks.norman.components.animation;

/**
 * @author Simon
 */
interface IAnimation extends IComponent
{
	public var paused( default, null ) : Bool;
	public function update( seconds : Float ) : Void;
	public function pause( ) : Void;
	public function resume( ) : Void;
}