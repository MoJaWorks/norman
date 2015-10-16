package uk.co.mojaworks.norman.components;
import uk.co.mojaworks.norman.systems.components.Component;

/**
 * ...
 * @author Simon
 */
class EventDispatcher extends Component
{
	
	public static inline var TYPE : String = "EventDispatcher";

	public function new() 
	{
		super( TYPE );
	}
	
}