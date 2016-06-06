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
	
		var vs = _context.createShader( GL.VERTEX_SHADER );
		_context.shaderSource( vs, shader.vertexSource );
		_context.compileShader( vs );
		
		var error : Int = _context.getError();
		if ( error > 0 ) {
			trace("Error compiling vertex shader", error );
		}
		
		var fs = _context.createShader( GL.FRAGMENT_SHADER );
		_context.shaderSource( fs, shader.fragmentSource );
		_context.compileShader( fs );
		
		error = _context.getError();
		if ( error > 0 ) {
			trace("Error compiling fragment shader", error );
		}
		
		var program : GLProgram = _context.createProgram();
		_context.attachShader( program, vs );
		_context.attachShader( program, fs );
		_context.linkProgram( program );
		
		error = _context.getError();
		if ( error > 0 ) {
			trace("Error linking shaders", error );
		}
		
		shader.glProgram = program;
		
		if ( error == 0 ) {
			trace("Uploaded shader" );
		}
		
	}
	
}