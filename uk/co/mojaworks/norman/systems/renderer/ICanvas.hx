package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.systems.renderer.batching.TargetBatch;
import uk.co.mojaworks.norman.systems.renderer.TextureData;

/**
 * @author Simon
 */

interface ICanvas 
{
	function getContext() : RenderContext;
	function getRenderTarget() : TextureData;
	
	function init( context : RenderContext ) : Void;
	function resize( width : Int, height : Int ) : Void;
	function render( vertices : Array<Float>, indices : Array<Int>, batch : TargetBatch ) : Void;
}