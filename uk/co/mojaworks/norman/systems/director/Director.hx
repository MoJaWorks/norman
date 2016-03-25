package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.components.delegates.BaseViewDelegate;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;
import uk.co.mojaworks.norman.factory.UIFactory;
import uk.co.mojaworks.norman.systems.SubSystem;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */

enum DisplayListAction {
	Added;
	Removed;
	Swapped;
	All;
}
 
class Director extends SubSystem
{

	var _container : GameObject;
	var _displayStack : Array<BaseViewDelegate>;
	
	public function new() 
	{
		super();
		_displayStack = [];
	}
	
	/**
	 * Screens
	 */
	
	public function moveToView( view : GameObject, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( transition == null ) transition = new Transition();
		transition.transition( BaseViewDelegate.getFromObject( view ), _displayStack, delay );
		
		_displayStack = [];
		_displayStack.push( cast view.getComponent(BaseViewDelegate.TYPE) );
		
		_container.transform.addChild( view.transform );
		
	}
	
	public function addView( view : GameObject, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( _displayStack.length > 0 ) _displayStack[_displayStack.length - 1].enabled = false;
		
		if ( transition == null ) transition = new Transition();
		transition.transition( BaseViewDelegate.getFromObject( view ), null, delay );
		
		_displayStack.push( BaseViewDelegate.getFromObject(view) );
		_container.transform.addChild( view.transform );
		
	}
	
	public function addBlocker( color : Color, transition : Transition = null, delay : Float = 0 ) : Void {
		
		var blocker : GameObject = UIFactory.createBlocker( color );		
		addView( blocker );
		
	}
	
	public function closeTopView( ) : Void {
		
		// Close the current view
		if ( _displayStack.length > 0 ) _displayStack.pop().hideAndDestroy();
		
		// Check for a blocker and remove
		if ( _displayStack.length > 0  && _displayStack[ _displayStack.length - 1 ].gameObject.name == "blocker" ) {
			_displayStack.pop().hideAndDestroy();
		}
		
		// Re-enable last window
		if ( _displayStack.length > 0  ) {
			_displayStack[_displayStack.length - 1].enabled = true;
		}
		
	}
	
}