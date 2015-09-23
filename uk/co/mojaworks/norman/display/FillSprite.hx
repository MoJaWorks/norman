package uk.co.mojaworks.norman.display;
import lime.math.Vector2;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author test
 */

enum FillSpriteShape {
	Rectangle;
	Ellipse;
}
 
class FillSprite extends Sprite
{
	
	// Set up default shader
	public static var defaultShader( get, null ) : ShaderData = null;
	public static function get_defaultShader( ) : ShaderData {
		if ( FillSprite.defaultShader == null ) {
			trace("Creating default fill shader");
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
			];
			
			FillSprite.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultFillVertexSource(), ShaderUtils.getDefaultFillFragSource(), atts );
		}
		return FillSprite.defaultShader;
	}
	
	public var color( default, default ) : Color;
	public var shader( default, default ) : ShaderData; 
	public var shape( get, set ) : FillSpriteShape;
	
	private var _shape : FillSpriteShape;	
	private var _vertices : Array<Vector2>;
	private var _indices : Array<Int>;

	public function new( color : Color, width : Float, height : Float, ?shape : FillSpriteShape = null ) 
	{
		super( );
				
		this.color = color;
		
		_width = width;
		_height = height;
		
		if ( shape != null ) {
			_shape = shape;
		}else {
			_shape = FillSpriteShape.Rectangle;
		}
			
		shouldRenderSelf = true;
		
		regeneratePoints();
	}
	
	public function set_shape( shape : FillSpriteShape ) : FillSpriteShape {
		_shape = shape;
		regeneratePoints();
		return shape;
	}
	
	public function get_shape( ) : FillSpriteShape {
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
					new Vector2( width, height),
					new Vector2(0, height),
					new Vector2(width, 0),
					new Vector2(0, 0)
				];
				_indices = Canvas.QUAD_INDICES;
				
			case Ellipse:
				
				_vertices = [
					new Vector2( width * 0.5, height * 0.5 ),
				];
				_indices = [];
				
				var quality : Int = 360;
				var radsPerVert : Float = (Math.PI * 2) / quality;
				
				for ( i in 0...quality ) {
					_vertices.push( new Vector2( (width * 0.5 * Math.cos( i * radsPerVert )) + (width * 0.5), (height * 0.5 * Math.sin( i * radsPerVert )) + (height * 0.5) ) );
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
				
				trace( "Ellipse", _vertices, _indices, quality, radsPerVert );
		}
		
	}
	
	override public function render(canvas:Canvas):Void 
	{
		super.render( canvas );
		canvas.draw( null, FillSprite.defaultShader, canvas.buildShapeVertexData( _vertices, renderMatrix, color.r, color.g, color.b, color.a * finalAlpha), _indices );
	}
	
}