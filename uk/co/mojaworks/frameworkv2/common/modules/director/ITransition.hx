package uk.co.mojaworks.frameworkv2.common.modules.director;
import openfl.display.Sprite;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * Transitions are like scripts but with the specific purpose of moving from one screen to another
 * @author Simon
 */

interface ITransition 
{
	function transition( parent : Sprite, to : GameObject, from : GameObject, allowAnimateOut : Bool = true ) : Void;
}