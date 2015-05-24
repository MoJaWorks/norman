package uk.co.mojaworks.norman.systems.renderer;
import haxe.Json;
import lime.Assets;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class TextureManager
{

	var _context : GLRenderContext;
	var _textures : Map<String,TextureData>;
	
	public function new() 
	{
	}
	
	public function init() : Void {
		_textures = new Map<String,TextureData>();
	}
	
	///
	
	public function createTextureFromAsset( id : String, allowCache : Bool = true ) : TextureData {
		
		if ( _textures.exists( id ) && allowCache ) {
			
			return _textures.get( id );
			
		}else{
		
			var image : Image = Assets.getImage( id );
			
			var map : Dynamic = null;
			if ( Assets.exists( id + ".map" ) ) {
				map = Json.parse( Assets.getText( id + ".map" ) );
			}
			
			return createTextureFromImage( id, image, map );
			
		}
		
	}
	
	///
	
	public function createTextureFromImage( id : String, image : Image, map : Dynamic = null ) : TextureData {
		
		var texture : TextureData = new TextureData();
		texture.sourceImage = image;
		texture.map = map;
		texture.isValid = false;
		texture.useCount = 0;
		texture.id = id;
		
		if ( _context != null ) {
			uploadTexture( texture );
		}
		
		_textures.set( id, texture );
		
		return texture;
		
	}
	
	///
	
	public function createTexture( id : String, width : Int, height : Int, fill : Color ) : TextureData {
		
		var image : Image = new Image( null, 0, 0, width, height, fill, null );
		return createTextureFromImage( id, image, null );
		
	}
	
	///
	
	public function onContextCreated( context : GLRenderContext ) : Void {
		
		_context = context;
		
		for ( texture in _textures ) {
			uploadTexture( texture );
		}
		
	}
	
	///
	
	
	private function uploadTexture( data : TextureData ) : Void {
		
		trace("Uploading ", data.id );
		
		var texture : GLTexture = _context.createTexture( );
		
		_context.bindTexture( GL.TEXTURE_2D, texture );
		_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE );
		_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE );
		#if html5
			_context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceImage.src );
		#else
			_context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, data.sourceImage.buffer.width, data.sourceImage.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceImage.data );
		#end
		//if ( !data.isRenderTexture ) {
			_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
			_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
		//}else {
		//	_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
		//	_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
		//}
		_context.bindTexture( GL.TEXTURE_2D, null );
		
		data.texture = texture;
	}
	
	
	public function unloadTexture( id : String ) : Void {
		
		var data : TextureData = _textures.get( id );
		if ( data != null ) {
			
			if ( data.texture != null && _context != null ) {
				_context.deleteTexture( data.texture );
			}
			
			data.isValid = false;
			_textures.remove( id );
			
		}
		
	}
	
}