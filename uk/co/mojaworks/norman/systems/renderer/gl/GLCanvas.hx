package uk.co.mojaworks.norman.systems.renderer.gl;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.math.Matrix3;
import lime.math.Rectangle;
import lime.math.Vector2;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class GLCanvas implements ICanvas
{

	var _context : GLRenderContext;
	var _batch : GLRenderBatch;
	
	public function new() 
	{
		
	}
	
	public function init( gl : GLRenderContext ) {
		_context = gl;
	}
	
	public function resize() : Void {
		// Does nothing - just here in case we need resize event
		// Get dimensions from the viewport
	}
	
	public function begin() : Void {
		
	}
	
	public function end() : Void {
		
	}
	
	public function fillRect( color : Color, transform : Matrix3, shaderId : String = "defaultFill" ) : Void 
	{
		if ( _batch.started && _batch.shaderId != shaderId ) {
			renderBatch();
			_batch.reset();
		}
		
		_batch.started = true;
		_batch.shaderId = shaderId;
		
		var points : Array<Vector2> = [
			new Vector2(0, 0),
			new Vector2(1, 0),
			new Vector2(0, 1),
			new Vector2(1, 1)
		];
		
		// Make points global with transform
		for ( i in 0...points.length ) {
			points[i] = transform.transformVector2( points[i] );
		}
		
		
		
	}
	
	private function renderBatch() : Void {
		
		// Render the current batch
		_context.drawArrays( GL.TRIANGLE_STRIP, 0, _batch.vertices.length );
	}
	
	
		
}