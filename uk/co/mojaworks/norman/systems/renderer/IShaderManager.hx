package uk.co.mojaworks.norman.systems.renderer;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * ...
 * @author test
 */
interface IShaderManager
{
	public function addShader( id : String, shaderData : ShaderData ) : Void;
}