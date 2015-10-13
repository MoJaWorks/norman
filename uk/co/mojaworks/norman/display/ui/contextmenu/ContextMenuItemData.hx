package uk.co.mojaworks.norman.display.ui.contextmenu;

/**
 * ...
 * @author Simon
 */
class ContextMenuItemData
{

	public var label : String;
	public var callback : Void->Void;
	
	public function new( label : String, callback : Void->Void ) 
	{
		this.label = label;
		this.callback = callback;
	}
	
}