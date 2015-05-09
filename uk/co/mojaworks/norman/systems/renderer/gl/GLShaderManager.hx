package uk.co.mojaworks.norman.systems.renderer.gl;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import uk.co.mojaworks.norman.systems.renderer.IShaderManager;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * ...
 * @author Simon
 */
class GLShaderManager implements IShaderManager
{

	var _context : GLRenderContext;
	
	var _programs : Map<String, GLProgram>;
	var _shaders : Map<String, ShaderData>;
	
	public function new() 
	{
	}
	
	public function init(  ) : Void {
		_programs = new Map<String,GLProgram>();
		_shaders = new Map<String,ShaderData>();
	}
	
	public function onContextCreated( context : Dynamic ) : Void {
		_context = cast context;
		
		// Make sure all shaders are compiled and uploaded
		for ( id in _shaders.keys() ) {
			uploadShader( id, _shaders.get( id ) );
		}
	}
	
	public function addShader( id:String, shaderData:ShaderData ) : Void 
	{
		if ( _context != null ) {
			
			_shaders.set( id, shaderData );
			uploadShader( id, shaderData );
			
		}
		
	}
	
	private function uploadShader( id : String, shader : ShaderData ) : Void {
	
		var vs = _context.createShader( GL.VERTEX_SHADER );
		_context.shaderSource( vs, shader.vertexSource );
		_context.compileShader( vs );
		
		var error : Int = _context.getError();
		if ( error > 0 ) {
			trace("Error compiling vertex shader for ", id );
		}
		
		var fs = _context.createShader( GL.FRAGMENT_SHADER );
		_context.shaderSource( fs, shader.fragmentSource );
		_context.compileShader( fs );
		
		error = _context.getError();
		if ( error > 0 ) {
			trace("Error compiling fragment shader for ", id );
		}
		
		var program : GLProgram = _context.createProgram();
		_context.attachShader( program, vs );
		_context.attachShader( program, fs );
		_context.linkProgram( program );
		
		error = _context.getError();
		if ( error > 0 ) {
			trace("Error linking shaders for ", id );
		}
		
		_programs.set( id, program );	
		
	}
	
}