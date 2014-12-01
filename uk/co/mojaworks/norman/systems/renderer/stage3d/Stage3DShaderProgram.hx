package uk.co.mojaworks.norman.systems.renderer.stage3d;
import com.adobe.utils.AGALMiniAssembler;
import flash.display3D.Context3D;
import flash.display3D.Program3D;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * ...
 * @author ...
 */
class Stage3DShaderProgram implements IShaderProgram
{

	private var _fsData : ShaderData;
	private var _vsData : ShaderData;
	
	public var program( default, null ) : Program3D;
	
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
	
	public function compile( context : Context3D ) : Void
	{
		#if gl_debug
			var debug : Bool  = true;
		#else
			var debug : Bool = false;
		#end
		
		var assembler : AGALMiniAssembler = new AGALMiniAssembler( debug );
		if ( program != null ) program.dispose();
		program = assembler.assemble2( context, 1, _vsData.getAGAL(), _fsData.getGLSL() );
		
	}
	
	
}