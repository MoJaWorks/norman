package uk.co.mojaworks.norman.systems.renderer.gl ;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.RenderContext;
import lime.utils.GLUtils;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * ...
 * @author Simon
 */
class GLShaderProgram implements IShaderProgram
{
	
	private var _fsData : ShaderData;
	private var _vsData : ShaderData;
	private var _context : GLRenderContext;
	
	public var program( default, null ) : GLProgram;
	
	/**
	 *
	 */

	public function new( context : GLRenderContext, vertexShader:ShaderData, fragmentShader:ShaderData ) 
	{
		_fsData = fragmentShader;
		_vsData = vertexShader;
		
		_context = context;
	}
	
	/**
	 * 
	 */
	
	public function compile(  ) : Void
	{
		
		if ( program != null ) _context.deleteProgram( program );
		program = GLUtils.createProgram( _vsData.getGLSL(), _fsData.getGLSL() );
		
		//var vs : GLShader = _context.createShader( GL.VERTEX_SHADER );
		//_context.shaderSource( vs, _vsData.getGLSL() );
		//_context.compileShader( vs );
		//
		//#if gl_debug
			//trace( _context.getShaderInfoLog( vs ) );
		//#end
		//
		//var fs : GLShader = _context.createShader( GL.FRAGMENT_SHADER );
		//_context.shaderSource( fs, _fsData.getGLSL() );
		//_context.compileShader( fs );
		//
		//#if gl_debug
			//trace( _context.getShaderInfoLog( fs ) );
		//#end
		//
		//program = _context.createProgram();
		//_context.attachShader( program, vs );
		//_context.attachShader( program, fs );
		//_context.linkProgram( program );
		//
		//#if gl_debug
			//trace( _context.getProgramInfoLog( program ) );
		//#end
		//
		//_context.deleteShader(vs);
		//_context.deleteShader(fs);
		
	}
	
		
}