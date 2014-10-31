package uk.co.mojaworks.norman.systems.renderer.gl ;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * ...
 * @author Simon
 */
class GLShaderProgram implements IShaderProgram
{
	
	private var _context : GLRenderContext;
	private var _fsData : ShaderData;
	private var _vsData : ShaderData;
	
	public var program( default, null ) : GLProgram;

	public function new( context : GLRenderContext, vertexShader:ShaderData, fragmentShader:ShaderData ) 
	{
		_context = context;
		_fsData = fragmentShader;
		_vsData = vertexShader;
		
		compile();
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.shaders.IShaderProgram */
	
	public function compile() 
	{
		
		if ( program ) _context.deleteProgram( program );
		
		var vs : GLShader = _context.createShader( GL.VERTEX_SHADER );
		_context.shaderSource( vs, _vsData.getGLSL() );
		_context.compileShader( vs );
		
		#if shader_debug
			trace( _context.getShaderInfoLog( vs ) );
		#end
		
		var fs : GLShader = _context.createShader( GL.FRAGMENT_SHADER );
		_context.shaderSource( fs, _fsData.getGLSL() );
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