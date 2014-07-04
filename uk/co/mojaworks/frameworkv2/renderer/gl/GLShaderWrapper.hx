package uk.co.mojaworks.frameworkv2.renderer.gl;
import openfl.Assets;
import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;

/**
 * ...
 * @author Simon
 */
class GLShaderWrapper
{

	public var program : GLProgram;
	
	public function new( vertexShaderSource : String, fragmentShaderSource : String ) 
	{
				
		var vs : GLShader = GL.createShader(GL.VERTEX_SHADER);
		GL.shaderSource(vs, vertexShaderSource );
		GL.compileShader(vs);
		
		if ( GL.getShaderParameter( vs, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile vertex shader!");
		}
		
		var fs : GLShader = GL.createShader(GL.FRAGMENT_SHADER);
		GL.shaderSource(fs, fragmentShaderSource );
		GL.compileShader(fs);
		
		if ( GL.getShaderParameter( fs, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile fragment shader!");
		}
		
		program = GL.createProgram();
		GL.attachShader( program, vs );
		GL.attachShader( program, fs );
		GL.linkProgram(program);
		
		if ( GL.getProgramParameter( program, GL.LINK_STATUS ) == 0 ) {
			trace("Shader link failed");
		}
				
	}
	
	public function getUniform( name : String ) : GLUniformLocation {
		return GL.getUniformLocation( program, name );
	}
	
	public function getAttrib( name : String ) : Int {
		return GL.getAttribLocation( program, name );
	}
	
}