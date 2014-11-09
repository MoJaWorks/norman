package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;
import uk.co.mojaworks.norman.systems.renderer.gl.GLShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
 
 
class Renderer
{	
	
	// Keep a cache of shaders so if the context is lost they can all be recreated quickly.
	private var _shaders : LinkedList<IShaderProgram>;
	
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
	 * 
	 */
	
	public function resize( width : Int, height : Int ) : Void {
		canvas.resize( width, height );
	}
	
	public function render( root : GameObject ) {
		
	}
	
	public function update(deltaTime:Float):Void 
	{
		
	}
	
	/**
	 * 	Shaders - native / stage3d only
	 */
	
	public function createShader( vs : ShaderData, fs : ShaderData ) : IShaderProgram {
		
		var shader : IShaderProgram = null;
		
		switch( canvas.getContext() ) {
			case RenderContext.OPENGL(gl):
				shader = new GLShaderProgram( gl, vs, fs );
			default:
				// Nothing yet
		}
		
		_shaders.push( shader );
		return shader;
	}
	
}