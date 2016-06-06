package uk.co.mojaworks.norman.components.renderer;
import geoff.renderer.Shader;
import geoff.utils.Color;
import hxmath.math.Vector2;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer.FillShape;
import uk.co.mojaworks.norman.core.renderer.Canvas;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author ...
 */

enum FillShape {
	Rectangle;
	Ellipse;
}
 
class ShapeRenderer extends BaseRenderer
{

	// Set up default shader
	public static var defaultShader( get, null ) : Shader = null;
	private static function get_defaultShader( ) : Shader {
		if ( ShapeRenderer.defaultShader == null ) {
			trace("Creating default fill shader");
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
			];
			
			ShapeRenderer.defaultShader = Core.instance.renderer.createShader( ShaderUtils.getDefaultFillVertexSource(), ShaderUtils.getDefaultFillFragSource(), atts );
		}
		return ShapeRenderer.defaultShader;
	}
	
	public var shape( get, set ) : FillShape;
	
	private var _shape : FillShape;	
	private var _vertices : Array<Vector2>;
	private var _indices : Array<Int>;
	private var _width : Float;
	private var _height : Float;

	public function new( color : Color, width : Float, height : Float, ?shape : FillShape = null ) 
	{
		super( );
				
		this.color = color;
		
		_width = width;
		_height = height;
		
		if ( shape != null ) {
			_shape = shape;
		}else {
			_shape = FillShape.Rectangle;
		}
			
		regeneratePoints();
	}
	
	public function set_shape( shape : FillShape ) : FillShape {
		_shape = shape;
		regeneratePoints();
		return shape;
	}
	
	public function get_shape( ) : FillShape {
		return _shape;
	}
		
	public function setSize( width: Float, height : Float ) : Void {
		_width = width;
		_height = height;
		regeneratePoints();
	}
	
	private function regeneratePoints() : Void {
		
		switch( shape ) {
			case Rectangle:
				
				_vertices = [
					new Vector2( _width, _height),
					new Vector2(0, _height),
					new Vector2(_width, 0),
					new Vector2(0, 0)
				];
				_indices = Canvas.QUAD_INDICES;
				
			case Ellipse:
				
				_vertices = [
					new Vector2( _width * 0.5, _height * 0.5 ),
				];
				_indices = [];
				
				var quality : Int = 360;
				var radsPerVert : Float = (Math.PI * 2) / quality;
				
				for ( i in 0...quality ) {
					_vertices.push( new Vector2( (_width * 0.5 * Math.cos( i * radsPerVert )) + (_width * 0.5), (_height * 0.5 * Math.sin( i * radsPerVert )) + (_height * 0.5) ) );
					if ( i < quality - 1 ) {
						_indices.push( 0 );
						_indices.push( i + 2 );
						_indices.push( i + 1 );
					}else if ( i == (quality - 1) ) {
						_indices.push( 0 );
						_indices.push( 1 );
						_indices.push( i + 1 );
					}
				}
				
				//trace( "Ellipse", _vertices, _indices, quality, radsPerVert );
		}
		
	}
	
	override public function render(canvas:Canvas):Void 
	{
		super.render( canvas );
		canvas.draw( null, ShapeRenderer.defaultShader, canvas.buildShapeVertexData( _vertices, gameObject.transform.renderMatrix, color.r, color.g, color.b, color.a * getCompositeAlpha()), _indices );
	}
	
	override private function get_width():Float 
	{
		return _width;
	}
	
	override private function get_height():Float 
	{
		return _height;
	}
	
	override private function set_width( val : Float ):Float 
	{
		_width = val;
		regeneratePoints();
		return _width;
	}
	
	override private function set_height( val : Float ):Float 
	{
		_height = val;
		regeneratePoints();
		return _height;
	}
	
	
	
}