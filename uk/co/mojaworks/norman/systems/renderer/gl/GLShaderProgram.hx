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
	
	public var program( default, null ) : GLProgram;
	
	/**
	 *
	 */

	public function new( vertexShader:ShaderData, fragmentShader:ShaderData ) 
	{
		_fsData = fragmentShader;
		_vsData = vertexShader;
	}
	
	/**
	 * 
	 */
	
	public function compile( context : GLRenderContext ) : Void
	{
		
		if ( program != null ) context.deleteProgram( program );
		program = GLUtils.createProgram( _vsData.getGLSL(), _fsData.getGLSL() );
		
	}
	
		
}