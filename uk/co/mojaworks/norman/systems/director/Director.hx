package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.data.NormanMessages;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;

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
	
	public static inline var SCREEN_LAYER : String = "DirectorScreensLayer";
	public static inline var MENU_LAYER : String = "DirectorMenuLayer";
	
	public var root : Sprite;
	public var rootObject : GameObject;
	public var sprites : Map<String,Sprite>;
	
	var _layers : Array<Sprite>;
	var _displayStack : Array<Screen>;
	
	public function new() 
	{
		sprites = new Map<String,Sprite>();
		_displayStack = [];
		_layers = [];
		
		root = new Sprite();
		rootObject = ObjectFactory.createGameObject( "Root" );
	}
	
	/**
	 * Screens
	 */
	
	public function moveToScreen( screen : Screen, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( transition == null ) transition = new Transition();
		transition.transition( screen, _displayStack, delay );
		
		_displayStack = [];
		_displayStack.push( screen );
		
		getLayer(SCREEN_LAYER).addChild( screen );
		
	}
	
	public function addScreen( screen : Screen, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( transition == null ) transition = new Transition();
		transition.transition( screen, null, delay );
		
		_displayStack.push( screen );
		getLayer(SCREEN_LAYER).addChild( screen );
	}
		
	
	/**
	 * Sprites
	 */
		
	public function registerSprite( sprite : Sprite, id : String ) : Void {
		sprites.set( id, sprite );
	}
	
	public function getSpriteWithID( id : String ) : Sprite {
		return sprites.get( id );
	}
		
	public function removeSprite( id : String ) : Void {
		sprites.remove( id );
	}
	
	
	/**
	 * Layers
	 */
	
	public function createLayer( name : String, index = -1 ) : Sprite {
		
		var spr : Sprite = new Sprite();
		spr.name = name;
		
		if ( index > -1 ) {
			_layers.insert( index, spr );
		}else {
			_layers.push( spr );
		}
		
		root.addChild( spr );
		spr.setChildIndex( index );
		
		return spr;
		
	}
	
	public function removeLayer( name : String ) : Void {
		
		var layer : Sprite = getLayer( name );
		
		if ( layer != null ) {
			_layers.remove( layer );
			layer.destroy();
		}		
		
	}
	
	public function getLayer( name : String ) : Sprite {
		
		for ( l in _layers ) {
			if ( l.name == name ) {
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
		for ( screen in _displayStack ) {
			screen.update( seconds );
		}
	}
	
	public function resize() : Void {
		
		// TODO: Remove this
		root.scaleX = Systems.viewport.scale;
		root.scaleY = Systems.viewport.scale;
		root.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		root.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
		rootObject.transform.scaleX = Systems.viewport.scale;
		rootObject.transform.scaleY = Systems.viewport.scale;
		rootObject.transform.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		rootObject.transform.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
		for ( screen in _displayStack ) {
			screen.resize();
		}

	}
	
	public function displayListChanged() 
	{
		root.updateDisplayOrder(0);
		rootObject.transform.updateDisplayOrder(0);
	}
	
}