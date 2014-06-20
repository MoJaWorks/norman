package uk.co.mojaworks.frameworkv2.common.modules.director ;
import openfl.display.DisplayObject;
import uk.co.mojaworks.frameworkv2.common.view.Mediator;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.common.engine.IGameObject;

/**
 * ...
 * @author Simon
 */
interface IView<T:(DisplayObject)> extends IGameObject
{
	
	var display( default, null ) : T;
	
		
	/**
	 * The view is about to be shown
	 */
	function onShow( ) : Void;
	
	/**
	 * The view is about to be hidden
	 * @return The amount of time the screen requires before hiding - usually 0 unless performaing an animate out
	 */
	public function onHide( ) : Float;
	
	/**
	 * The view is about to be deactivated
	 */
	function onDeactivate( ) : Void;
	
	/**
	 * The view is about to be activated
	 */
	public function onActivate( ) : Float;

	
}