package uk.co.mojaworks.norman.components.director.ui ;

import uk.co.mojaworks.norman.core.Component;

/**
 * Used to add screens/panels to the director
 * Extend this class to specify functionality for each screen
 * ...
 * @author Simon
 */
class View extends Component
{

	public static inline var SHOWN : String = "VIEW_SHOWN";
	public static inline var ACTIVATE : String = "VIEW_ACTIVATE";
	public static inline var DEACTIVATE : String = "VIEW_DEACTIVATE";
	public static inline var RESIZE : String = "VIEW_RESIZE";
	
	public var active : Bool = false;
	
	public function new() 
	{
		super();
	}
	
	public function onShow() : Void {
		gameObject.messenger.sendMessage( SHOWN );
	}
	
	public function onActivate() : Void {
		gameObject.messenger.sendMessage( ACTIVATE );
	}
	
	public function onDeactivate() : Void {
		gameObject.messenger.sendMessage( DEACTIVATE );
	}
	
	public function resize() : Void {
		gameObject.messenger.sendMessage( RESIZE );
	}
	
}