package uk.co.mojaworks.norman.components.director ;

import uk.co.mojaworks.norman.components.director.ui.View;
import uk.co.mojaworks.norman.components.director.ui.ViewSpace;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Director extends Component
{
	
	public var viewport( default, null ) : Viewport;
	
	// All items presented including the main view are added to this space
	// When a new view is loaded - all items in this space will be removed
	var _currentSpace : GameObject;
	var _previousSpace : GameObject;
	
	public function new() 
	{
		super();
		viewport = new Viewport();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		root.add( new Sprite() );
	}
	
	public function setViewportTarget( width : Int, height : Int ) : Void {
		viewport.setTargetSize( width, height );
	}
	
	/**
	 * 
	 */
	
	public function moveToView( view : GameObject, ?transitionType : Class<ITransition> = null ) : Void {
		
		// Swap spaces
		_previousSpace = _currentSpace;
		_currentSpace = new GameObject().add(new Sprite()).add(new ViewSpace());
		_currentSpace.get(ViewSpace).addView( view );
		root.addChild( _currentSpace );
		
		// Build the transition
		var t : ITransition = null;
		if ( transitionType != null ) t = Type.createInstance( transitionType, [] );
		if ( t != null ) {
			t.transition( _previousSpace, _currentSpace, onSpaceChanged );
		}else {
			onSpaceChanged( _previousSpace, _currentSpace );
		}
		
	}
	
	private function onSpaceChanged( from : GameObject, to : GameObject ) : Void {
		
		// Destroy the old space
		if ( from != null ) {
			root.removeChild( from );
			from.destroy();
		}
		
		// Activate the new one
		if ( to != null ) {
			var view : View = to.get(ViewSpace).currentActiveView.get(View);
			view.onShow();
			view.onActivate();
		}		
	}
	
	/**
	 * Presents a new view in the current space
	 */
	
	public function presentView( view : GameObject, ?transitionType : Class<ITransition> = null ) : Void {
		
		// Deactivate the current view
		var prev_view : GameObject = _currentSpace.get(ViewSpace).currentActiveView;
		if ( prev_view != null ) prev_view.get(View).onDeactivate();
		
		// Add the new view
		_currentSpace.get(ViewSpace).addView( view );
		
		// Transition to the new view
		var t : ITransition = null;
		if ( transitionType != null ) t = Type.createInstance( transitionType, [] );
		if ( t != null ) {
			t.transition( prev_view, view, onPresentationComplete );
		}else {
			onPresentationComplete( prev_view, view );
		}
		
	}
	
	private function onPresentationComplete( from : GameObject, to : GameObject ) : Void {
		var view : View = to.get(View);
		view.onShow();
		view.onActivate();
	}
	
	/**
	 * Dismisses the current active view but remains in the current space
	 */
	
	private function dismissCurrentView( ?transitionType : Class<ITransition> = null ) : Void {
				
		// Deactivate the current view
		var prev_view : GameObject = _currentSpace.get(ViewSpace).currentActiveView;
		if ( prev_view != null ) prev_view.get(View).onDeactivate();
		
		var next_view : GameObject = _currentSpace.get(ViewSpace).previousView;
				
		// Transition to the old view (by removing the new one)
		var t : ITransition = null;
		if ( transitionType != null ) t = Type.createInstance( transitionType, [] );
		if ( t != null ) {
			t.transition( prev_view, next_view, onDismissComplete );
		}else {
			onDismissComplete( prev_view, next_view );
		}		
	
	}	
	
	private function onDismissComplete( from : GameObject, to : GameObject ) : Void {
		
		if ( from != null ) {
			_currentSpace.get(ViewSpace).removeView( from );
		}
		
		if ( to != null ) {
			to.get(View).onActivate();
		}		
	}
		
	/**
	 * 
	 */
	
	public function resize( ) : Void {
		
		viewport.resize();
		root.transform.setScale( viewport.scale ).setPosition( viewport.screenRect.x, viewport.screenRect.y );
		
		if ( _currentSpace != null ) {
			_currentSpace.get(ViewSpace).resize();
		}
		
	}
	
}