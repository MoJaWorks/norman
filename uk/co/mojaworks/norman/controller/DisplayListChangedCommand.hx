package uk.co.mojaworks.norman.controller;

import uk.co.mojaworks.norman.systems.director.Director.DisplayListAction;
import uk.co.mojaworks.norman.systems.switchboard.MessageData;
import uk.co.mojaworks.norman.systems.switchboard.SimpleCommand;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class DisplayListChangedCommand extends SimpleCommand
{

	public function new() 
	{
		super();
		
	}
	
	override function action(messageData:MessageData):Void 
	{
		super.action(messageData);
		
		var action : DisplayListAction = cast messageData.data;
		
		if ( action != DisplayListAction.Removed ) {
			// For these it currently doesnt matter if items are removed - only added or moved
			Systems.director.displayListChanged();
			Systems.ui.displayListChanged();
		}
	}
	
}