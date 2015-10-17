package uk.co.mojaworks.norman.components.delegates;

import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.ui.MouseEvent;

/**
 * ...
 * @author Simon
 */
class AbstractUIDelegate extends Component
{

	public function new() 
	{
	}
	
	public function onAdded( ) : Void {
		Systems.ui.add( this );
	}
	
	public function onRemoved( ) : Void {
		Systems.ui.remove( this );
	}
	
	public function processEvent( e : MouseEvent ) : Void {
		
		switch( e.type ) {
			case Down:
				onMouseDown( e );
		}
		
	}
	
	public function onMouseDown( e : MouseEvent ) : Void {}
	public function onMouseUp( e : MouseEvent ) : Void {}
	public function onMouseOver( e : MouseEvent ) : Void {}
	public function onMouseOut( e : MouseEvent ) : Void {}
	public function onClick( e : MouseEvent ) : Void {}
	
}