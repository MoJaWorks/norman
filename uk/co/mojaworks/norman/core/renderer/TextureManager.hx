package uk.co.mojaworks.norman.core.renderer;
import geoff.renderer.IRenderContext;
import geoff.renderer.Texture;
import geoff.assets.Assets;
import geoff.utils.Color;
import haxe.Json;
import haxe.io.Bytes;
import haxe.io.UInt8Array;

/**
 * ...
 * @author test
 */
class TextureManager
{

	var _context : IRenderContext;
	var _textures : Map<String,Texture>;
	
	public function new() 
	{
	}
	
	public function init() : Void {
		trace("Booting texture manager...");
		_textures = new Map<String,Texture>();
	}
	
	///
	
	public function createTextureFromAsset( path : String, useCache : Bool = true ) : Texture {
		
		//trace("Creating texture from asset with id " + id );
		
		if ( _textures.exists( path ) && useCache ) {
			
			return _textures.get( path );
			
		}else{
				
			var texture : Texture = _context.createTextureFromAsset( path );
			
			if ( _context != null ) {
				_context.uploadTexture( texture );
			}
			
			_textures.set( path, texture );
			
			return texture;
			
		}
		
	}
	
	public function createTextureFromPixels( id : String, width : Int, height : Int, pixels : Bytes ) : Texture {
		
		var texture : Texture = _context.createTextureFromPixels( id, width, height, pixels );
			
		if ( _context != null ) {
			_context.uploadTexture( texture );
		}
		
		_textures.set( id, texture );
		
		return texture;
		
	}
	
		
	///
	
	public function onContextCreated( context : IRenderContext ) : Void {
		
		_context = context;
		
		for ( texture in _textures ) {
			_context.uploadTexture( texture );
		}
		
	}
	
	///
	
	public function uploadTexture( id : String ) : Void 
	{
		if ( _textures.exists( id ) )
			_context.uploadTexture( _textures.get( id ) );
	}
	
		
	public function unloadTexture( id : String ) : Void {
		
		var data : Texture = _textures.get( id );
		if ( data != null ) {
			
			if ( data.textureId != 0 && _context != null ) {
				_context.destroyTexture( data );
			}
			
			data.isValid = false;
			_textures.remove( id );
			
		}
		
	}
	
}