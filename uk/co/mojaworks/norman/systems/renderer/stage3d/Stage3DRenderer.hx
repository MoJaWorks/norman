package uk.co.mojaworks.norman.systems.renderer.stage3d;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import haxe.Json;
import lime.Assets;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.utils.UInt8Array;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.renderer.gl.GLTextureData;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.IRenderer;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.LinkedList;


/**
 * ...
 * @author ...
 */
class Stage3DRenderer implements IRenderer
{

	// Keep a cache of shaders so if the context is lost they can all be recreated quickly.
	private var _shaders : LinkedList<Stage3DShaderProgram>;
	private var _textures : Map<String, Stage3DTextureData>;
	
	private var _canvas : Stage3DCanvas;
	
	public function new( context : Context3D ) 
	{
		_shaders = new LinkedList<Stage3DShaderProgram>();
		_textures = new Map<String,Stage3DTextureData>();
		_canvas = new Stage3DCanvas( context );
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
		
		var shader : Stage3DShaderProgram = new Stage3DShaderProgram( vs, fs );
		
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
	
	public function createTexture( id : String, width : Int, height : Int ) : ITextureData {
		
		//var img : Image = new Image( new ImageBuffer( new UInt8Array( width * height * 4 ), width, height ), 0, 0, width, height );
		var img : Image = new Image( new ImageBuffer( new UInt8Array( width * height * 4 ), width, height, 4), 0, 0, width, height );
		return createTextureFromImage( id, img, null );
		
	}
	
	public function createTextureFromAsset( id : String ) : ITextureData {
		
		var map : String = null;
		if ( Assets.exists( id + ".map" ) ) map = Assets.getText( id + ".map" );
		
		return createTextureFromImage( id, Assets.getImage( id ), map );
	}

	/**
	 * Creates a texture, also assigns a texture map in the form of a json string
	 * Given an id, it can be referenced multiple times while only loaded once
	 * 
	 * @param	data
	 * @param	map
	 */
	public function createTextureFromImage( id : String, image : Image, map : String = null ) : ITextureData {
		
		var data : Stage3DTextureData = new Stage3DTextureData();
		data.id = id;
		data.sourceImage = image;
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
		
		var data : Stage3DTextureData = getTexture(id);
		if ( data != null ) {
			data.texture.dispose();
			data.isValid = false;
			_textures.remove( id );
		}
		
	}
	
	/**
	 * 
	 * @param	data
	 * @return
	 */
	
	private function uploadTexture( data : Stage3DTextureData ) : Texture {
		
		var context : Context3D = _canvas.getContext();
		var tex : Texture = context.createTexture( data.sourceImage.width, data.sourceImage.height, Context3DTextureFormat.BGRA, false );
		tex.uploadFromBitmapData( data.sourceImage.src );
		return tex;
	}
	
	/**
	 * 
	 */
	
	public function getTexture( id : String ) : Stage3DTextureData {
		return _textures.get(id);
	}
	
	public function hasTexture( id : String ) : Bool {
		return (_textures.get(id) != null);
	}
	
	public function reviveTexture( data : ITextureData ) : Void {
		
		var stage3d_data : Stage3DTextureData = cast data;
		_textures.set( data.id, stage3d_data );
		stage3d_data.texture = uploadTexture( stage3d_data );
		stage3d_data.isValid = true;
	}
	
	public function getCanvas() : ICanvas {
		return _canvas;
	}
	
}