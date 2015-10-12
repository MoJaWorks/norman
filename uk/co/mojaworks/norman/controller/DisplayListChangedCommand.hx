package uk.co.mojaworks.norman.controller;

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
		
		trace("director display list changed");
		Systems.director.displayListChanged();
		
		trace("ui display list changed");
		Systems.ui.displayListChanged();
	}
	
}