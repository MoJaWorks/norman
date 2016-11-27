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
	var _newShaders : Array<Shader>;
	
	public function new() 
	{
		_newShaders = [];
		_shaders = [];
	}
	
	public function init(  ) : Void {
		
	}
	
	public function onContextCreated( context : IRenderContext ) : Void {
		
		_context = context;
		_newShaders = [];
		
		// Make sure all shaders are compiled and uploaded
		for ( shader in _shaders ) {
			///uploadShader( shader );
			_newShaders.push( shader );
		}
		
	}
	
	public function createShader( vs : String, fs : String, attributes : Array<ShaderAttribute> = null ) : Shader 
	{
				
		var shader : Shader = new Shader( vs, fs, attributes );
		
		_shaders.push( shader );
		//if ( _context != null ) {
		//	uploadShader( shader );
		//}
		_newShaders.push( shader );
		
		return shader;
		
	}
	
	public function uploadNewShaders() : Void 
	{
		while ( _newShaders.length > 0 )
		{
			uploadShader( _newShaders.pop() );
		}
	}

	
	private function uploadShader( shader : Shader ) : Void {
	
		_context.uploadShader( shader );
		
	}
	
}