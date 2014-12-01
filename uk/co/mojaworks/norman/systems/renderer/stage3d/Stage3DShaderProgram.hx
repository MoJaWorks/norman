package uk.co.mojaworks.norman.systems.renderer.stage3d;
import com.adobe.utils.AGALMiniAssembler;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import lime.utils.ByteArray;
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
		
		if ( program != null ) program.dispose();
		
		var assembler : AGALMiniAssembler = new AGALMiniAssembler();
		var vs : ByteArray = assembler.assemble( Context3DProgramType.VERTEX, _vsData.getAGAL() );
		var fs : ByteArray = assembler.assemble( Context3DProgramType.FRAGMENT, _fsData.getAGAL() );
		program = context.createProgram();
		program.upload( vs, fs );
		
	}
	
	
}