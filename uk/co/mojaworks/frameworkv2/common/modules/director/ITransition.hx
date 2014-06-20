package uk.co.mojaworks.frameworkv2.common.modules.director;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

/**
 * Transitions are like scripts but with the specific purpose of moving from one screen to another
 * @author Simon
 */

interface ITransition 
{
	function transition( parent : Sprite, to : IView<DisplayObject>, from : IView<DisplayObject>, allowAnimateOut : Bool = true ) : Void;
}