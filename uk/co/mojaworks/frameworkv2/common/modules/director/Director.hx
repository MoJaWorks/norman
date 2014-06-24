package uk.co.mojaworks.frameworkv2.common.modules.director ;

import motion.Actuate;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.common.engine.GameEngine;
import uk.co.mojaworks.frameworkv2.common.modules.director.transitions.ImmediateTransition;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Director extends Component
{
	
	var currentScreen( default, null ) : GameObject;
	var _panelStack : Array<GameObject>;
	var _blocker : Sprite;
	
	public var root(default, null) : Sprite;
	var _screenLayer : Sprite;
	var _panelLayer : Sprite;
	
	public var currentActiveView(get, never) : GameObject;
	
	public function new() 
	{
		super();
		_panelStack = [];
		
		root = new Sprite();
				
		_screenLayer = new Sprite();
		root.addChild( _screenLayer );
		
		_blocker = new Sprite();
		root.addChild( _blocker );
		
		_panelLayer = new Sprite();
		root.addChild( _panelLayer );
		
	}
	
	/**
	 * SCREENS
	 */
	
	public function showScreen( view : GameObject, ?transitionType : Class<ITransition> = null, allowAnimateOut : Bool = true ) : Void {
		
		var t : ITransition;
		if ( transitionType != null ) t = Type.createInstance( transitionType, [] );
		else t = new ImmediateTransition();
		
		t.transition( _screenLayer, view, currentScreen, allowAnimateOut );
	}
	
	/**
	 * PANELS
	 */
	
	public function showPanel( panel : GameObject ) : Void {
		
		if ( _panelStack.length == 0 ) {
			_blocker.alpha = 0;
			_blocker.visible = true;
			Actuate.tween( _blocker, 0.25, { alpha: 1 } );
			
			currentScreen.onDeactivate();
		}
		
		panel.onShow();
		panel.onActivate();
		root.addChild( panel.display );
	}
	
	
	public function hidePanel( panel : GameObject ) : Void {
		
		panel.onDeactivate();
		
		var time : Float = panel.onHide();
		if ( time > 0 ) {
			Actuate.timer( time ).onComplete( onPanelHidden, [panel, true] );
		}else {
			onPanelHidden( panel, true );
		}
	}
	
		
	private function onPanelHidden( view : GameObject, isPanel : Bool  ) : Void {
		
		// Clean up the view
		view.destroy();
		
		_panelStack.remove( view );
		_panelLayer.removeChild( view.display );
		if ( _panelStack.length == 0 ) {
			Actuate.tween( _blocker, 0.25, { alpha: 0 } ).onComplete( function() { _blocker.visible = false; } );
		}
		
		// Activate next panel in stack or screen if no more panels
		currentActiveView.onActivate();
	}
	
	/**
	 * 
	 */
	
	public function resize( ) : Void {
		
		var screenRect : Rectangle = core.get(GameEngine).viewport.displayRect;
		
		// Send the resize message to the stack
		_blocker.graphics.clear();
		_blocker.graphics.beginFill( 0, 0.7 );
		_blocker.graphics.drawRect( screenRect.x, screenRect.y, screenRect.width, screenRect.height );
		_blocker.graphics.endFill();
	}
	
	
	private function get_currentActiveView() : GameObject {
		if ( _panelStack.length > 0 ) {
			return _panelStack[ _panelStack.length - 1];
		}
		return currentScreen;
	}
	
}