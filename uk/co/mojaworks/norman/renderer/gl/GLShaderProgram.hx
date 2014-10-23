package uk.co.mojaworks.norman.renderer.gl;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.renderer.shaders.ShaderData;

/**
 * ...
 * @author Simon
 */
class GLShaderProgram implements IShaderProgram
{
	
	private var _context : GLRenderContext;
	private var program( default, null ) : GLProgram;

	public function new( context : GLRenderContext ) 
	{
		_context = context;
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.shaders.IShaderProgram */
	
	public function compile( vertexShader:ShaderData, fragmentShader:ShaderData ) 
	{
		
		if ( program ) _context.deleteProgram( program );
		
		var vs : GLShader = _context.createShader( GL.VERTEX_SHADER );
		_context.shaderSource( vs, vertexShader.getGLSL() );
		_context.compileShader( vs );
		
		#if shader_debug
			trace( _context.getShaderInfoLog( vs ) );
		#end
		
		var fs : GLShader = _context.createShader( GL.FRAGMENT_SHADER );
		_context.shaderSource( fs, fragmentShader.getGLSL() );
		_context.compileShader( fs );
		
		#if shader_debug
			trace( _context.getShaderInfoLog( fs ) );
		#end
		
		program = _context.createProgram();
		program.attach( vs );
		program.attach( fs );
		_context.linkProgram( program );
		
		#if shader_debug
			trace( _context.getProgramInfoLog( program ) );
		#end
		
		_context.deleteShader(vs);
		_context.deleteShader(fs);
		
	}
	
}