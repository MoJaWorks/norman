package uk.co.mojaworks.norman.systems.renderer.shaders ;

/**
 * ...
 * @author Simon
 */
interface IShaderProgram
{
	public function compile(vertexShader : ShaderData, fragmentShader : ShaderData);	
}