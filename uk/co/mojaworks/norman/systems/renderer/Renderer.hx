package uk.co.mojaworks.norman.systems.renderer;
import flash.display3D.textures.TextureBase;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.display.FillSprite;
import uk.co.mojaworks.norman.components.display.ImageSprite;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.core.ISystem;
import uk.co.mojaworks.norman.systems.renderer.batching.RenderBatch;
import uk.co.mojaworks.norman.systems.renderer.batching.ShaderBatch;
import uk.co.mojaworks.norman.systems.renderer.batching.TextureBatch;
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
	private var _batches : RenderBatch;
	
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
		
		//_batches = new RenderBatch();
		//_batches.items.push( new TextureBatch() );
		//_batches.items.first.item.texture = null;
		//_batches.items.first.item.items.push( new ShaderBatch() );
		//_batches.items.first.item.items.shader = FillSprite.shaderProgram;
		
	}
	
	/**
	 * Collections
	 */
	
	public function addSprite( sprite : Sprite ) : Void {
		
		
		
		//if ( !_collection.contains( sprite ) ) _collection.push( sprite );	
		//var texture : TextureData = null;
		//var img : ImageSprite = cast( sprite, ImageSprite );
		//if ( img != null ) texture = img.textureData;
		//
		//for ( rb in _batches ) {
			//if ( texture == rb.texture ) {
				//rb.
			//}
		//}
	}
	
	public function removeSprite( sprite : Sprite ) : Void {
		_batches.batches.first.item.batches.remove( sprite );
	}
	
	/**
	 * 
	 */
	
	public function resize( width : Int, height : Int ) : Void {
		canvas.resize( width, height );
	}
	
	public function render( camera : GameObject ) {
		canvas.render( _collection, camera );
	}
	
	public function update(deltaTime:Float):Void 
	{
		// TODO: Sort all of the display items based on shader, texture and target
	}
	
	/**
	 * 
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