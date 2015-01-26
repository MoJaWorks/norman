package uk.co.mojaworks.norman.systems.renderer.stage3d;
import haxe.ds.Vector;

/**
 * ...
 * @author ...
 */
class Stage3DRenderBatch
{

	public var shader : Stage3DShaderProgram;
	public var texture : Stage3DTextureData;
	public var vertices : flash.Vector<Float>;
	public var indices : flash.Vector<UInt>;
	public var started : Bool;
	
	public function new() 
	{
		reset();
	}
	
	public function reset() : Void {
		shader = null;
		texture = null;
		vertices = new flash.Vector<Float>();
		indices = new flash.Vector<UInt>();
		started = false;
	}
	
}