package uk.co.mojaworks.frameworkv2.renderer;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLTexture;

/**
 * ...
 * @author Simon
 */
class GLTile
{

	var _vertexBuffer : GLBuffer;
	var _texture : GLTexture;
	var _tint : ColorTransform;
	
	var _source : BitmapData;
	var _sourceRect : Rectangle;
	
	var _transform : Matrix3D;
	
	public function new( ) 
	{
		_tint = new ColorTransform();
	}
	
	public function render( canvas : GLCanvas ) : Void {
		
		
		
	}
	
}