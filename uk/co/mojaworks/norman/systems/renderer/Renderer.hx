package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.display.Camera;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.core.ISystem;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class Renderer implements ISystem
{
	private var _collection : LinkedList<Sprite>;
	public var canvas : ICanvas;
	
	public function new( context : RenderContext ) 
	{
		switch( context ) {
			case RenderContext.OPENGL(gl):
				canvas = new GLCanvas();
				canvas.init( cast gl );
			
			default:
				// Nothing yet
		}
		
	}
	
	/**
	 * Collections
	 */
	
	public function addSprite( sprite : Sprite ) : Void {
		if ( !_collection.contains( sprite ) ) _collection.push( sprite );
	}
	
	public function removeSprite( sprite : Sprite ) : Void {
		_collection.remove( sprite );
	}
	
	/**
	 * 
	 */
	
	public function resize( width : Int, height : Int ) : Void {
		canvas.resize( width, height );
	}
	
	public function render( context : RenderContext, root : GameObject, camera : GameObject ) {
		canvas.render( root, camera );
	}
	
	public function update(deltaTime:Float):Void 
	{
		// Sort all of the display items based on shader, texture and target
		
		// First sort by target into separate lists
		canvas.
	}
	
}