package uk.co.mojaworks.frameworkv2.renderer;
import openfl.display.BitmapData;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLTexture;

/**
 * ...
 * @author Simon
 */
class GLTile
{

	static var _textures : Map<String, GLTexture>();
	
	var _vertexBuffer : GLBuffer;
	var _texture : GLTexture;
	
	var _source : BitmapData;
	var _sourceRect : Rectangle;
	
	var _transform : Matrix3D;
	
	public function new() 
	{
		
	}
	
	public function render() : Void {
		
	}
	
}