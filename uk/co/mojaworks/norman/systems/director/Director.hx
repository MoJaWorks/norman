package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.components.delegates.BaseViewDelegate;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;
import uk.co.mojaworks.norman.factory.UIFactory;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */

enum DisplayListAction {
	Added;
	Removed;
	Swapped;
	All;
}
 
class Director
{
	
	public static inline var BACKGROUND_LAYER : String = "DirectorBackgroundLayer";
	public static inline var VIEW_LAYER : String = "DirectorViewLayer";
	public static inline var MENU_LAYER : String = "DirectorMenuLayer";
	
	public var rootObject : GameObject;
	public var objects : Map<String,GameObject>;
	
	var _layers : Array<Transform>;
	var _displayStack : Array<BaseViewDelegate>;
	var _background : BaseViewDelegate;
	
	public function new() 
	{
		objects = new Map<String,GameObject>();
		_displayStack = [];
		_layers = [];
		
		rootObject = ObjectFactory.createGameObject( "Root" );
		
	}
	
	public function setBackground( background : GameObject ) : Void {
				
		var backgroundLayer : Transform = getLayer( BACKGROUND_LAYER );
		
		if ( _background != null ) _background.gameObject.destroy();
		_background = BaseViewDelegate.getFromObject( background );
		backgroundLayer.addChild( background.transform );
		
	}
	
	/**
	 * Screens
	 */
	
	public function moveToView( view : GameObject, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( transition == null ) transition = new Transition();
		transition.transition( view, _displayStack, delay );
		
		_displayStack = [];
		_displayStack.push( cast view.getComponent(BaseViewDelegate.TYPE) );
		
		getLayer(VIEW_LAYER).addChild( view.transform );
		
	}
	
	public function addView( view : GameObject, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( _displayStack.length > 0 ) _displayStack[_displayStack.length - 1].enabled = false;
		
		if ( transition == null ) transition = new Transition();
		transition.transition( view, null, delay );
		
		_displayStack.push( BaseViewDelegate.getFromObject(view) );
		getLayer(VIEW_LAYER).addChild( view.transform );
		
	}
	
	public function addBlocker( color : Color, transition : Transition = null, delay : Float = 0 ) : Void {
		
		var blocker : GameObject = UIFactory.createBlocker( color );		
		addView( blocker );
		
	}
	
	public function closeTopView( ) : Void {
		
		// Close the current view
		if ( _displayStack.length > 0 ) _displayStack.pop().hideAndDestroy();
		
		// Check for a blocker and remove
		if ( _displayStack.length > 0  && _displayStack[ _displayStack.length - 1 ].gameObject.id == "blocker" ) {
			_displayStack.pop().hideAndDestroy();
		}
		
		// Re-enable last window
		if ( _displayStack.length > 0  ) {
			_displayStack[_displayStack.length - 1].enabled = true;
		}
		
	}
		
	
	/**
	 * Sprites
	 */
		
	public function registerObject( obj : GameObject ) : Void {
		objects.set( obj.id, obj );
	}
	
	public function getObjectWithID( id : String ) : GameObject {
		return objects.get( id );
	}
		
	public function removeObject( id : String ) : Void {
		objects.remove( id );
	}
	
	
	/**
	 * Layers
	 */
	
	public function createLayer( name : String, index = -1 ) : Transform {
		
		//var spr : Sprite = new Sprite();
		//spr.name = name;
		var layer : GameObject = ObjectFactory.createGameObject( "/@normanLayers/" + name );
		var trans : Transform = layer.transform;
		
		if ( index > -1 ) {
			_layers.insert( index, trans );
		}else {
			_layers.push( trans );
		}
		
		rootObject.transform.addChild( trans );
		return trans;
		
	}
	
	public function removeLayer( name : String ) : Void {
		
		var layer : Transform = getLayer( name );
		
		if ( layer != null ) {
			_layers.remove( layer );
			layer.destroy();
		}		
		
	}
	
	/**
	 * Gets a layer - creates a new one if it doesn't already exist
	 * @return
	 */
	public function getLayer( name : String ) : Transform {
		
		for ( l in _layers ) {
			if ( l.gameObject.id == "/@normanLayers/" + name ) {
				return l;
			}
		}
		
		return createLayer( name );
		
	}
		
	
	/**
	 * Ongoing
	 */
	
	
	public function update( seconds : Float ) : Void 
	{
		if ( _background != null ) _background.update( seconds );
		
		for ( screen in _displayStack ) {
			screen.update( seconds );
		}
	}
	
	public function resize() : Void {
				
		rootObject.transform.scaleX = Systems.viewport.scale;
		rootObject.transform.scaleY = Systems.viewport.scale;
		rootObject.transform.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		rootObject.transform.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
		if ( _background != null ) _background.resize();
		
		for ( screen in _displayStack ) {
			screen.resize();
		}

	}
	
	public function displayListChanged() : Void
	{
		rootObject.transform.updateDisplayOrder(0);
	}
	
}