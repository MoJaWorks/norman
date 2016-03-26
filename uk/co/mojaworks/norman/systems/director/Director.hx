package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.systems.Systems.SubSystem;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.components.delegates.BaseViewDelegate;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;
import uk.co.mojaworks.norman.factory.UIFactory;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */

class Director extends SubSystem
{
	
	public var container( default, null ) : GameObject;
	
	var _displayStack : Array<BaseViewDelegate>;
	
	public function new() 
	{
		super();
		_displayStack = [];
		container = ObjectFactory.createGameObject( "director" );
	}
	
	/**
	 * Screens
	 */
	
	public function moveToView( view : GameObject, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( transition == null ) transition = new Transition();
		transition.transition( view.get( BaseViewDelegate ), _displayStack, delay );
		
		_displayStack = [];
		_displayStack.push( cast view.get(BaseViewDelegate) );
		
		trace("Display stack", _displayStack );
		
		container.transform.addChild( view.transform );
		
	}
	
	public function addView( view : GameObject, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( _displayStack.length > 0 ) _displayStack[_displayStack.length - 1].enabled = false;
		
		if ( transition == null ) transition = new Transition();
		transition.transition( view.get(BaseViewDelegate), null, delay );
		
		_displayStack.push( view.get(BaseViewDelegate) );
		container.transform.addChild( view.transform );
		
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
	
	public function resize() : Void 
	{
		for ( item in _displayStack ) 
		{
			item.resize();
		}
	}
	
	
	override public function update( seconds : Float ) : Void 
	{
		for ( item in _displayStack )
		{
			item.update( seconds );
		}
	}
	
}