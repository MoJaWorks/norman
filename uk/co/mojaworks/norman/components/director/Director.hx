package uk.co.mojaworks.norman.components.director ;

import motion.Actuate;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.components.engine.GameEngine;
import uk.co.mojaworks.norman.components.director.transitions.ImmediateTransition;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Director extends Component
{
	
	var currentScreen( default, null ) : GameObject;
	var _panelStack : Array<GameObject>;
	var _blocker : GameObject;
	
	public var root(default, null) : GameObject;
	var _screenLayer : GameObject;
	var _panelLayer : GameObject;
	
	public var currentActiveView(get, never) : GameObject;
	
	public function new() 
	{
		super();
		_panelStack = [];
		
		root = new GameObject();
				
		_screenLayer = new GameObject();
		root.addChild( _screenLayer );
		
		_blocker = new GameObject();
		root.addChild( _blocker );
		
		_panelLayer = new GameObject();
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
			var blockerDisplay : Display = _blocker.get(Display);
			blockerDisplay.alpha = 0;
			blockerDisplay.visible = true;
			Actuate.tween( blockerDisplay, 0.25, { alpha: 1 } );
			
			currentScreen.get(View).onDeactivate();
		}
		
		var panelView : View = panel.get(View);
		panelView.onShow();
		panelView.onActivate();
		_panelLayer.addChild( panel );
		_panelStack.push( panel );
	}
	
	
	public function hidePanel( panel : GameObject ) : Void {
		
		var panelView : View = panel.get(View);
		panelView.onDeactivate();
		
		var time : Float = panelView.onHide();
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
		_panelLayer.removeChild( view );
		if ( _panelStack.length == 0 ) {
			var blockerDisplay : Display = _blocker.get(Display);
			Actuate.tween( blockerDisplay, 0.25, { alpha: 0 } ).onComplete( function() { blockerDisplay.visible = false; } );
		}
		
		// Activate next panel in stack or screen if no more panels
		currentActiveView.get(View).onActivate();
	}
	
	/**
	 * 
	 */
	
	public function resize( ) : Void {
		
		var screenRect : Rectangle = core.root.get(Viewport).displayRect;
		
		// TODO: Resize the blocker
		
		if ( currentScreen != null ) currentScreen.get(View).resize();
		for ( view in _panelStack ) {
			view.get(View).resize();
		}
		
	}
	
	
	private function get_currentActiveView() : GameObject {
		if ( _panelStack.length > 0 ) {
			return _panelStack[ _panelStack.length - 1];
		}
		return currentScreen;
	}
	
}