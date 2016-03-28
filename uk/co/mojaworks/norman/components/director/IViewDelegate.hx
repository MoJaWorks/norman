package uk.co.mojaworks.norman.components.director;
import uk.co.mojaworks.norman.factory.GameObject;

/**
 * @author Simon
 */
interface IViewDelegate extends IComponent
{
	public var active( default, set ) : Bool;
	public function build() : Void;
	public function show() : Void;
	public function hideAndDestroy() : Void;
	public function resize() : Void;
	public function update( seconds : Float ) : Void;
	
}