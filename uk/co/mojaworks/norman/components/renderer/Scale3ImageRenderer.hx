package uk.co.mojaworks.norman.components.renderer;

import geoff.math.Matrix3;
import geoff.math.Rect;
import geoff.math.Vector2;
import geoff.renderer.Texture;
import uk.co.mojaworks.norman.core.renderer.Canvas;

/**
 * ...
 * @author Simon
 */

enum Scale3Type {
	Horizontal;
	Vertical;
}
 
class Scale3ImageRenderer extends ImageRenderer
{

	public var scale3Rect( default, default ) : Rect = null;
	public var scale3Type( default, default ) : Scale3Type = Horizontal;
	
	public function new(texture:Texture, subTextureId:String=null) 
	{
		super(texture, subTextureId);
	}
	
	public function setScale3Rect( rect : Rect ) : Void 
	{
		this.scale3Rect = rect;
	}
	
	public function setScale3Type( type : Scale3Type ) : Void 
	{
		this.scale3Type = type;
	}
	
	
	override public function render(canvas:Canvas):Void 
	{		
		if ( texture != null ) {
			
			if ( scale3Rect == null ) {
			
				super.render( canvas );
				
			}else {
			
				var t : Transform = gameObject.transform;
				var uvRect : Rectangle = new Rectangle();
				var vertexData : Array<Float> = [];
				var m = new Matrix3();
				
				var centerUV : Rect = new Rect( 
					imageUVRect.x + ( ( scale3Rect.left / width ) * imageUVRect.width ),
					imageUVRect.y + ( ( scale3Rect.top / height ) * imageUVRect.height ),
					( scale3Rect.width / width ) * imageUVRect.width,
					( scale3Rect.height / height ) * imageUVRect.height
				);
				
				if ( scale3Type == Horizontal ) {
					
					var lostWidth = scaledWidth - ((scale3Rect.width * t.scaleX) + scale3Rect.x + (width - scale3Rect.right));
					var extraScaleX = (scale3Rect.width + (lostWidth / t.scaleX)) / scale3Rect.width;
					
					// top left
					m.identity();
					m.translate( -t.anchorX, -t.anchorY );
					m.scale( 1, t.scaleY );
					m.rotate( t.rotation );
					m.translate( t.x, t.y );
					if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
					uvRect.setTo( imageUVRect.x, imageUVRect.y, centerUV.left, imageUVRect.bottom );
					vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
					
					// top center
					m.identity();
					m.translate( -t.anchorX, -t.anchorY );
					m.scale( t.scaleX * extraScaleX, t.scaleY );
					m.translate( scale3Rect.x, 0 );
					m.rotate( t.rotation );
					m.translate( t.x , t.y );
					if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
					uvRect = new Rectangle( centerUV.left, imageUVRect.y, centerUV.width, imageUVRect.bottom );
					vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
					
					// top right
					m.identity();
					m.translate( -t.anchorX + scale3Rect.left + (scale3Rect.width * extraScaleX * t.scaleX), -t.anchorY );
					m.scale( 1, t.scaleY );
					m.rotate( t.rotation );
					m.translate( t.x, t.y );
					if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
					uvRect = new Rectangle( centerUV.right, imageUVRect.top, imageUVRect.right - centerUV.right, imageUVRect.bottom );
					vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				}else {
						
					var lostHeight = scaledHeight - ((scale3Rect.height * t.scaleY) + scale3Rect.y + (height - scale3Rect.bottom));
					var extraScaleY = (scale3Rect.height + (lostHeight / t.scaleY)) / scale3Rect.height;
					
					// top left
					m.identity();
					m.translate( -t.anchorX, -t.anchorY );
					m.scale( t.scaleX, 1 );
					m.rotate( t.rotation );
					m.translate( t.x, t.y );
					if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
					uvRect.setTo( imageUVRect.x, imageUVRect.y, imageUVRect.width, centerUV.top );
					vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
					
					// center left
					m.identity();
					m.translate( -t.anchorX, -t.anchorY );
					m.scale( t.scaleX, t.scaleY * extraScaleY );
					m.translate( 0, scale3Rect.y );
					m.rotate( t.rotation );
					m.translate( t.x, t.y );
					if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
					uvRect.setTo( imageUVRect.x, centerUV.top, imageUVRect.width, centerUV.height );
					vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
					
					m.identity();
					m.translate( -t.anchorX, -t.anchorY + scale3Rect.top + (scale3Rect.height * extraScaleY * t.scaleY) );
					m.scale( t.scaleX, 1 );
					m.rotate( t.rotation );
					m.translate( t.x, t.y );
					if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
					uvRect.setTo( imageUVRect.x, centerUV.bottom, imageUVRect.width, imageUVRect.bottom - centerUV.bottom );
					vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				}
				
				var indices : Array<Int> = [];
				
				for ( s in 0...3 ) {
					for ( i in Canvas.QUAD_INDICES ) {
						indices.push( (4 * s) + i );
					}
				}
				
				canvas.draw( _textureArray, ImageRenderer.defaultShader, vertexData, indices );
				
			}
		}
	}
}