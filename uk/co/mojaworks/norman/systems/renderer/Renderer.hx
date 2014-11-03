package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.core.ISystem;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;
import uk.co.mojaworks.norman.systems.renderer.gl.GLShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
 
class Renderer implements ISystem
{	

	// Keep a cache of shaders so if the context is lost they can all be recreated quickly.
	private var _shaders : LinkedList<IShaderProgram>;
	
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
	
	public function render( context : RenderContext, camera : GameObject ) {
		canvas.render( _collection, camera );
	}
	
	public function update(deltaTime:Float):Void 
	{
		// TODO: Sort all of the display items based on shader, texture and target
	}
	
	/**
	 * 
	 */
	
	public function createShader( vs : IShaderData, fs : IShaderData ) : IShaderProgram {
		
		var shader : IShaderProgram;
		
		switch( canvas.getContext() ) {
			RenderContext.OPENGL(gl):
				shader = new GLShaderProgram( gl, vs, fs );
			default:
				// Nothing yet
		}
		
		_shaders.push( shader );
		return shader;
	}
	
}