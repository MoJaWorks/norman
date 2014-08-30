package uk.co.mojaworks.norman.components.input ;

import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class TouchListener extends Component
{

	public function new() 
	{
		super();
	}
	
	override public function onAdded() : Void {
		root.get(Input).addTouchListener( gameObject );
	}
	
	override public function onRemoved() : Void {
		root.get(Input).removeTouchListener( gameObject );
	}
	
}