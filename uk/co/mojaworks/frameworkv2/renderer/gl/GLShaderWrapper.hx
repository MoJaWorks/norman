package uk.co.mojaworks.frameworkv2.renderer.gl;
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
	public var uniforms : Map<String, GLUniformLocation>;
	public var attributes : Map<String, Int>;
	
	public function new( vertexShaderSource : String, fragmentShaderSource : String, uniformNames : Array<String>, attributeNames : Array<String> ) 
	{
				
		var vs : GLShader = GL.createShader(GL.VERTEX_SHADER);
		GL.shaderSource(vs, vertexShaderSource );
		GL.compileShader(vs);
		
		if ( GL.getShaderParameter( vs, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile vertex shader!");
		}
		
		var fs : GLShader = GL.createShader(GL.FRAGMENT_SHADER);
		GL.shaderSource(fs, Assets.getText("shaders/main.fs.glsl"));
		GL.compileShader(fs);
		
		if ( GL.getShaderParameter( fs, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile fragment shader!");
		}
		
		program = GL.createProgram();
		GL.attachShader( program, vs );
		GL.attachShader( program, fs );
		GL.linkProgram(program);
		
		if ( GL.getProgramParameter( _shaderProgram, GL.LINK_STATUS ) == 0 ) {
			trace("Shader link failed");
		}
		
		attributes = new Map<String,Int>();
		for ( att in attributeNames ) {
			attributes.set( att, GL.getAttribLocation( program, att ) );
		}
		
		uniforms = new Map<String,GLUniformLocation>();
		for ( uniform in uniformNames ) {
			uniforms.set( uniform, GL.getUniformLocation( program, uniform ) );
		}
		
	}
	
}