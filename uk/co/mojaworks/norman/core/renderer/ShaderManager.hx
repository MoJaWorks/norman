package uk.co.mojaworks.norman.core.renderer;
import geoff.renderer.IRenderContext;
import geoff.renderer.Shader;


/**
 * Responsible for uploading and maintaing shaders
 * ...
 * @author Simon
 */
class ShaderManager
{

	var _context : IRenderContext;
	var _shaders : Array<Shader>;
	
	public function new() 
	{
	}
	
	public function init(  ) : Void {
		
		_shaders = [];
	}
	
	public function onContextCreated( context : IRenderContext ) : Void {
		
		_context = context;
		
		// Make sure all shaders are compiled and uploaded
		for ( shader in _shaders ) {
			uploadShader( shader );
		}
		
	}
	
	public function createShader( vs : String, fs : String, attributes : Array<ShaderAttribute> = null ) : Shader 
	{
				
		var shader : Shader = new Shader( vs, fs, attributes );
		
		_shaders.push( shader );
		if ( _context != null ) {
			uploadShader( shader );
		}
		
		return shader;
		
	}

	
	private function uploadShader( shader : Shader ) : Void {
	
		_context.uploadShader( shader );
		
	}
	
}