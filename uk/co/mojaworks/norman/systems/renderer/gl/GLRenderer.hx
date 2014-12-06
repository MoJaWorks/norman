package uk.co.mojaworks.norman.systems.renderer.gl;
import haxe.Json;
import lime.Assets;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import lime.utils.UInt16Array;
import lime.utils.UInt8Array;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;
import uk.co.mojaworks.norman.systems.renderer.gl.GLShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.IRenderer;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
 
 
class GLRenderer implements IRenderer
{	
	
	// Keep a cache of shaders so if the context is lost they can all be recreated quickly.
	private var _shaders : LinkedList<GLShaderProgram>;
	private var _textures : Map<String, GLTextureData>;
	
	private var _canvas : GLCanvas;
	
	public function new( context : GLRenderContext ) 
	{
		_shaders = new LinkedList<GLShaderProgram>();
		_textures = new Map<String,GLTextureData>();
		_canvas = new GLCanvas( context );
	}
	
	/**
	 * 
	 */
	
	public function resize( width : Int, height : Int ) : Void {
		_canvas.resize( width, height );
	}
	
		
	/**
	 * 	Shaders - native / stage3d only
	 */
	
	public function createShader( vs : ShaderData, fs : ShaderData ) : IShaderProgram {
		
		var shader : GLShaderProgram = new GLShaderProgram( vs, fs );
		
		if ( _canvas.getContext() != null ) {
			shader.compile( _canvas.getContext() ); 
		}
		#if gl_debug
			else {
				trace("Deferred creating shader until context is restored");
			}
		#end
		
		_shaders.push( shader );
		return shader;
	}
	
	/**
	 * Render
	 * @param	root
	 */
	
	public function render( root : GameObject ) : Void {
		_canvas.begin();
		_canvas.clear();
		renderLevel( root );
		_canvas.complete();
	}
	
	private function renderLevel( object : GameObject ) : Void {
		
		if ( object.sprite != null ) {
			
			if ( object.sprite.preRender( _canvas ) ) {
				object.sprite.render( _canvas );
				for ( child in object.children ) {
					renderLevel( child );
				}
			}else {
			}
			
			object.sprite.postRender( _canvas );
		}else {
			// No Sprite to report to just render the Children
			for ( child in object.children ) {
				renderLevel( child );
			}
		}
		
	}
	
	/**
	 * Textures
	 */
	
	public function createTexture( id : String, width : Int, height : Int, asRenderTexture : Bool = false ) : ITextureData {
		
		var img : Image = new Image( null, 0, 0, width, height );
		return createTextureFromImage( id, img, null, asRenderTexture );
		
	}
	
	public function createTextureFromAsset( id : String, asRenderTexture : Bool = false ) : ITextureData {
		
		var map : String = null;
		if ( Assets.exists( id + ".map" ) ) map = Assets.getText( id + ".map" );
		
		return createTextureFromImage( id, Assets.getImage( id ), map, asRenderTexture );
	}

	/**
	 * Creates a texture, also assigns a texture map in the form of a json string
	 * Given an id, it can be referenced multiple times while only loaded once
	 * 
	 * @param	data
	 * @param	map
	 */
	public function createTextureFromImage( id : String, image : Image, map : String = null, asRenderTexture : Bool = false ) : ITextureData {
		
		var data : GLTextureData = new GLTextureData();
		data.id = id;
		data.sourceImage = image;
		data.isRenderTexture = asRenderTexture;
		if ( map != null ) data.map = Json.parse( map );
		
		if ( _canvas.getContext() != null ) {
			data.texture = uploadTexture( data );
		}
			#if gl_debug
				else {
					trace("Deferred creating texture until context is restored", id);
				}
			#end
		
		return data;
	}
	
	public function destroyTexture( id : String ) : Void {
		
		var data : GLTextureData = getTexture(id);
		if ( data != null ) {
			if ( _canvas.getContext() != null ) {
				_canvas.getContext().deleteTexture( data.texture );
			}
			data.isValid = false;
			_textures.remove( id );
		}
		
	}
	
	/**
	 * 
	 * @param	data
	 * @return
	 */
	
	private function uploadTexture( data : GLTextureData ) : GLTexture {
		
		var context : GLRenderContext = _canvas.getContext();
		var tex : GLTexture = context.createTexture();
		
		context.bindTexture( GL.TEXTURE_2D, tex );
		context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE );
		context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE );
		#if html5
			context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceImage.src );
		#else
			context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, data.sourceImage.buffer.width, data.sourceImage.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceImage.data );
		#end
		if ( !data.isRenderTexture ) {
			context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
			context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
		}else {
			context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
			context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
		}
		context.bindTexture( GL.TEXTURE_2D, null );
		
		return tex;
	}
	
	/**
	 * 
	 */
	
	public function getTexture( id : String ) : GLTextureData {
		return _textures.get(id);
	}
	
	public function hasTexture( id : String ) : Bool {
		return (_textures.get(id) != null);
	}
	
	public function reviveTexture( data : ITextureData ) : Void {
		
		var gl_data : GLTextureData = cast data;
		_textures.set( data.id, gl_data );
		gl_data.texture = uploadTexture( gl_data );
		gl_data.isValid = true;
	}
	
	public function getCanvas() : ICanvas {
		return _canvas;
	}
	
}