package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.display.ImageSprite;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.core.ISystem;
import uk.co.mojaworks.norman.systems.renderer.batching.RenderBatch;
import uk.co.mojaworks.norman.systems.renderer.batching.ShaderBatch;
import uk.co.mojaworks.norman.systems.renderer.batching.TargetBatch;
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
	private var _batch : TargetBatch;
	
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
		
		_batch = new TargetBatch();
		
		// This will be for the sprites without textures
		_batch.items.push( new TextureBatch() );
				
	}
	
	/**
	 * Collections
	 */
	
	public function addSprite( sprite : Sprite ) : Void {
		
			
		var placed : Bool = false;
		
		// All render targets are the same for now so just using a single target
		if ( sprite.isTextured ) {
			
			// Get the image
			var img : ImageSprite = cast sprite;
			
			// Check for any texture batches using this image
			for ( textureBatch in _batch.items ) {
				
				// Found a matching texture
				if ( img.textureData == textureBatch.texture ) {
					
					// Check for a matching shader
					for ( shaderBatch in textureBatch.items ) {
						
						// Found a matching shader
						if ( shaderBatch.shader == sprite.getShader() ) {
							shaderBatch.items.push( sprite );								
							placed = true;
						}
						
					}
					
					// Couldn't find the shader - make a new shader batch
					if ( !placed ) {
						var shaderBatch : ShaderBatch = new ShaderBatch();
						shaderBatch.shader = sprite.getShader();
						shaderBatch.items.push( sprite );
						textureBatch.items.push( shaderBatch );
						placed = true;
					}
					
				}
				
				// Couldn't find the texture, create a new one
				if ( !placed ) {
					var textureBatch : TextureBatch = new TextureBatch();
					textureBatch.texture = img.textureData;
					textureBatch.items.push( new ShaderBatch() );
					textureBatch.items[0].shader = sprite.getShader();
					textureBatch.items[0].items.push( sprite );
					_batch.items.push( textureBatch );
					placed = true;
				}
			}
		}else {
			
			// Always use textureBatch 0 for non-textures items
			// Check for a matching shader
			for ( shaderBatch in _batch.items[0].items ) {
				
				// Found a matching shader
				if ( shaderBatch.shader == sprite.getShader() ) {
					shaderBatch.items.push( sprite );								
					placed = true;
				}
				
			}
			
			// Couldn't find the shader - make a new shader batch
			if ( !placed ) {
				var shaderBatch : ShaderBatch = new ShaderBatch();
				shaderBatch.shader = sprite.getShader();
				shaderBatch.items.push( sprite );
				_batch.items[0].items.push( shaderBatch );
				placed = true;
			}
			
		}
		
		if ( !placed ) trace("Something went wrong, sprite could not be placed", sprite.gameObject );
	}
	
	public function removeSprite( sprite : Sprite ) : Void {
		
		if ( sprite.isTextured ) {
			var img : ImageSprite = cast sprite;
			for ( textureBatch in _batch.items ) {
				if ( textureBatch.texture == img.textureData ) {
					for ( shaderBatch in textureBatch.items ) {
						if ( sprite.getShader() == shaderBatch.shader ) {
							shaderBatch.items.remove( sprite );
						}
					}
				}
			}
		}else{
			for ( shaderBatch in _batch.items[0].items ) {
				if ( sprite.getShader() == shaderBatch.shader ) {
					shaderBatch.items.remove( sprite );
				}
			}
		}
	}
	
	/**
	 * 
	 */
	
	public function resize( width : Int, height : Int ) : Void {
		canvas.resize( width, height );
	}
	
	public function render( camera : GameObject ) {
		
		// TODO: create the vertex/index arrays and batch info	
		// TODO: Pass these to the canvas for rendering
		
		var vertices : Array<Float> = [];
		var indices : Array<Int> = [];
		
		for ( texture in _batch.items ) {
			for ( shader in texture.items ) {
				for ( object in shader.items ) {
					
					shader.start = indices.length;
					
					vertices.push( object.getVertices() );
					indices.push( object.getIndices() );
					
					shader.length = indices.length - shader.start;
										
				}				
			}			
		}
		
		canvas.render( vertices, indices, _batch );
		
	}
	
	public function update(deltaTime:Float):Void 
	{
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