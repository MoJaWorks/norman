package uk.co.mojaworks.norman.components.director.ui ;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class ViewSpace extends Component
{

	public var viewStack : LinkedList<GameObject>;
	public var currentActiveView( get, never ) : GameObject;
	public var previousView( get, never ) : GameObject;
	
	public function new() 
	{
		super();
		viewStack = new LinkedList<GameObject>();
	}
	
	private function get_currentActiveView() : GameObject {
		if ( viewStack.length > 0 ) {
			return viewStack.last.item;
		}
		return null;
	}
	
	private function get_previousView() : GameObject {
		if ( viewStack.length > 1 ) {
			return viewStack.last.prev.item;
		}
		return null;
	}
	
	override public function destroy() : Void {
		for ( view in viewStack ) {
			view.destroy();
		}
		viewStack.clear();
		viewStack = null;
	}
	
	public function addView( view : GameObject ) : Void {
		viewStack.push( view );
		gameObject.addChild( view );
	}
	
	public function removeView( view : GameObject ) : Void {
		viewStack.remove( view );
		gameObject.removeChild( view );
		view.destroy();
	}
	
	public function resize() : Void {
		for ( view in viewStack ) {
			view.get(View).resize();
		}
	}
	
}