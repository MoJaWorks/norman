package uk.co.mojaworks.norman.core.renderer;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import uk.co.mojaworks.norman.core.renderer.ShaderData;

/**
 * Responsible for uploading and maintaing shaders
 * ...
 * @author Simon
 */
class ShaderManager
{

	var _context : GLRenderContext;
	var _shaders : Array<ShaderData>;
	
	public function new() 
	{
	}
	
	public function init(  ) : Void {
		
		_shaders = [];
	}
	
	public function onContextCreated( context : GLRenderContext ) : Void {
		
		_context = context;
		
		// Make sure all shaders are compiled and uploaded
		for ( shader in _shaders ) {
			uploadShader( shader );
		}
		
	}
	
	public function createShader( vs : String, fs : String, attributes : Array<ShaderAttributeData> = null ) : ShaderData 
	{
				
		var shader : ShaderData = new ShaderData( vs, fs, attributes );
		
		_shaders.push( shader );
		if ( _context != null ) {
			uploadShader( shader );
		}
		
		return shader;
		
	}

	
	private function uploadShader( shader : ShaderData ) : Void {
	
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