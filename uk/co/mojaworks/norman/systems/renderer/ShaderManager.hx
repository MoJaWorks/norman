package uk.co.mojaworks.norman.systems.renderer;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultFillShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * ...
 * @author Simon
 */
class ShaderManager
{

	var _context : GLRenderContext;
	var _shaders : Map<String, ShaderData>;
	
	public function new() 
	{
	}
	
	public function init(  ) : Void {
		
		_shaders = new Map<String,ShaderData>();
		
		// Create default shaders
		addShader( new DefaultFillShader() );
	}
	
	public function onContextCreated( context : GLRenderContext ) : Void {
		
		_context = context;
		
		// Make sure all shaders are compiled and uploaded
		for ( id in _shaders.keys() ) {
			uploadShader( _shaders.get( id ) );
		}
		
	}
	
	public function addShader( shaderData : ShaderData ) : Void 
	{
		if ( _context != null ) {
			
			_shaders.set( shaderData.id, shaderData );
			uploadShader( shaderData );
			
		}
		
	}
	
	public function getProgram( shaderId : String) : GLProgram
	{
		return _shaders.get( shaderId ).program;
	}
	
	private function uploadShader( shader : ShaderData ) : Void {
	
		var vs = _context.createShader( GL.VERTEX_SHADER );
		_context.shaderSource( vs, shader.vertexSource );
		_context.compileShader( vs );
		
		var error : Int = _context.getError();
		if ( error > 0 ) {
			trace("Error compiling vertex shader for ", shader.id );
		}
		
		var fs = _context.createShader( GL.FRAGMENT_SHADER );
		_context.shaderSource( fs, shader.fragmentSource );
		_context.compileShader( fs );
		
		error = _context.getError();
		if ( error > 0 ) {
			trace("Error compiling fragment shader for ", shader.id );
		}
		
		var program : GLProgram = _context.createProgram();
		_context.attachShader( program, vs );
		_context.attachShader( program, fs );
		_context.linkProgram( program );
		
		error = _context.getError();
		if ( error > 0 ) {
			trace("Error linking shaders for ", shader.id );
		}
		
		_shaders.get( shader.id ).program = program;	
		
	}
	
}