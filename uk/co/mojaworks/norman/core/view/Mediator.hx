package uk.co.mojaworks.norman.core.view;

import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.CoreObject;

/**
 * ...
 * @author ...
 */
class Mediator extends CoreObject
{

	public var view : GameObject;
	
	public function new() 
	{
		super();
		view = new GameObject().add( new Sprite() );
	}
	
}