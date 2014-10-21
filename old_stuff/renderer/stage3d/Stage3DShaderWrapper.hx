package uk.co.mojaworks.norman.components.renderer.stage3d ;
import com.adobe.utils.AGALMiniAssembler;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import openfl.utils.ByteArray;

/**
 * ...
 * @author Simon
 */
class Stage3DShaderWrapper
{

	public var program : Program3D;
	public var vertexShader : ByteArray;
	public var fragmentShader : ByteArray;
	
	public function new( context : Context3D, vertexShaderSource : String, fragmentShaderSource : String ) 
	{
		
		var assembler : AGALMiniAssembler = new AGALMiniAssembler();
		vertexShader = assembler.assemble( Context3DProgramType.VERTEX, vertexShaderSource );
		fragmentShader = assembler.assemble( Context3DProgramType.FRAGMENT, fragmentShaderSource );
		program = context.createProgram();
		program.upload( vertexShader, fragmentShader );
		
	}
	
}