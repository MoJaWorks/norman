package uk.co.mojaworks.norman.systems.director ;

import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.components.ui.View;
import uk.co.mojaworks.norman.components.Viewport;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.systems.AppSystem;

/**
 * ...
 * @author Simon
 */
class Director extends AppSystem
{
	
	public var root(default, null) : GameObject;
	public var currentActiveView(get, never) : GameObject;
	
	var _viewStack : Array<GameObject>;
	
	public function new() 
	{
		super();
		_viewStack = [];
		root = new GameObject().add( new Display() );
	}
	
	/**
	 * 
	 */
	
	public function moveToView( view : GameObject, ?transitionType : Class<ITransition> = null ) : Void {
		changeView( view, onTransitionComplete, transitionType );
	}
	
	public function presentView( view : GameObject, ?transitionType : Class<ITransition> = null ) : Void {
		changeView( view, onPresentationComplete, transitionType );
	}
	
	private function dismissCurrentView( ?transitionType : Class<ITransition> = null ) : Void {
		
		var next_view : GameObject = null;
		if ( _viewStack.length > 1 ) {
			next_view = _viewStack[_viewStack.length - 2];
		}
		
		changeView( next_view, onTransitionComplete, transitionType );
		
	}
	
	/**
	 * 
	 */
	
	private function changeView( view : GameObject, callback : GameObject->GameObject->Void, ?transitionType : Class<ITransition> ) {
		
		var t : ITransition = null;
		if ( transitionType != null ) t = Type.createInstance( transitionType, [] );
		
		var prev_view : GameObject = currentActiveView;
		
		if ( prev_view != null ) prev_view.get(View).onDeactivate();
		root.addChild( view );
		_viewStack.push( view );
		
		if ( t != null ) {
			t.transition( prev_view, view, callback );
		}else {
			callback( prev_view, view );
		}
		
	}
	
	private function onTransitionComplete( from : GameObject, to : GameObject ) : Void {
		
		if ( from != null ) {
			_viewStack.remove( from );
			root.removeChild( from );
			from.destroy();
		}
		
		if ( to != null ) {
			to.get(View).onActivate();
		}		
	}
	
	private function onPresentationComplete( from : GameObject, to : GameObject ) : Void {
		to.get(View).onActivate();
	}
	
	
	
		
	/**
	 * 
	 */
	
	public function resize( ) : Void {
		
		var viewport : Viewport = core.app.viewport;
		root.transform.setScale( viewport.scale ).setPosition( viewport.screenRect.x, viewport.screenRect.y );
		
		for ( view in _viewStack ) {
			view.get(View).resize();
		}
		
	}
	
	
	private function get_currentActiveView() : GameObject {
		if ( _viewStack.length > 0 ) {
			return _viewStack[ _viewStack.length - 1];
		}
		return null;
	}
		
}