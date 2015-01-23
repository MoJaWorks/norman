package uk.co.mojaworks.norman.systems.ui;
import uk.co.mojaworks.norman.components.ui.UITouchListener;
import uk.co.mojaworks.norman.systems.input.TouchData;

/**
 * ...
 * @author Simon
 */
class UITouchData extends TouchData
{

	var primaryTarget : UITouchListener;
	
	public function new() 
	{
		
	}
	
	public static function from( touchData : TouchData ) : UITouchData {
		var _new = new UITouchData();
		_new.isDown = touchData.isDown;
		_new.lastTouchEnd = touchData.lastTouchEnd.clone();
		_new.lastTouchStart = touchData.lastTouchStart.clone();
		_new.position = touchData.position.clone();
		_new.touchId = touchData.touchId;
		return _new;
	}
	
}