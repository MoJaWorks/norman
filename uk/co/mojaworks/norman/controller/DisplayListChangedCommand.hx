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
		
		Systems.director.displayListChanged();
		Systems.ui.displayListChanged();
	}
	
}