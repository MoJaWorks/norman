package uk.co.mojaworks.norman.systems.director ;
import openfl.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * Transitions are like scripts but with the specific purpose of moving from one screen to another
 * @author Simon
 */

interface ITransition 
{
	function transition( from : GameObject, to : GameObject, callback : GameObject->GameObject->Void ) : Void;
}