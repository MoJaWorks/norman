package uk.co.mojaworks.norman.systems.renderer;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;

/**
 * ...
 * @author test
 */
interface IShaderManager
{
	public function init() : Void;
	
	public function onContextCreated( context : Dynamic ) : Void;
	public function addShader( id : String, shaderData : ShaderData ) : Void;
}