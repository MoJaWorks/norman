package uk.co.mojaworks.norman.display;
import uk.co.mojaworks.norman.geom.Transform;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author test
 */
class Sprite
{
	
	public var alpha( default, default ) : Float = 1;
	public var finalAlpha( get, never ) : Float;
	
	public var parent( default, set ) : Sprite;
	public var children( default, null ) : LinkedList<Sprite>;
	
	public var width( get, null ) : Float = 0;
	public var height( get, null ) : Float = 0;	
	public var transform( default, null ) : Transform;
	
	// Render flags
	public var shouldRenderSelf : Bool = false;
	public var shouldRenderChildren : Bool = true;

	public function new( ) 
	{		
		children = new LinkedList<Sprite>();
		transform = new Transform( this );
	}
	
	public function get_width() : Float {
		// Override this
		return this.width;
	}
	
	public function get_height() : Float {
		// Override this
		return this.height;
	}
	
	public function get_finalAlpha() : Float {
		if ( parent != null ) {
			return parent.finalAlpha * alpha;
		}else {
			return alpha;
		}
	}
	
	public function preRender( canvas : Canvas ) : Void {
		// Override
	}
	
	public function render( canvas : Canvas ) : Void {
		// Override
	}
	
	public function postRender( canvas : Canvas ) : Void {
		// Override
	}
	
	public function addChild( sprite : Sprite ) : Void {
		
		// Remove from existing parent
		if ( sprite.parent != null ) sprite.parent.removeChild( sprite );
		
		sprite.parent = this;
		children.push( sprite );
	}
	
	public function removeChild( sprite : Sprite ) : Void {
		sprite.parent = null;
		children.remove( sprite );
	}
	
	public function set_parent( parent : Sprite ) : Sprite {
		this.parent = parent;
		return parent;
	}
	
	public function resize() : Void {
		
	}
	
	public function destroy() : Void {
		
		for ( child in children ) {
			child.destroy();
		}
		
		children.clear();
		children = null;
		parent = null;
		
		transform.destroy();
		transform = null;
	}
	
}