package uk.co.mojaworks.norman.components.renderer;

import lime.math.Matrix3;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.TextureData;

/**
 * ...
 * @author Simon
 */
class Scale9ImageRenderer extends ImageRenderer
{

	public var scale9Rect( default, null ) : Rectangle = null;
	
	public function new(texture:TextureData, subTextureId:String=null) 
	{
		super(texture, subTextureId);
	}
	
	public function setScale9Rect( rect : Rectangle ) : Void 
	{
		this.scale9Rect = rect;
	}
	
	
	override public function render(canvas:Canvas):Void 
	{		
		if ( texture != null ) {
			
			if ( scale9Rect == null ) {
			
				super.render( canvas );
				
			}else {
			
				var t : Transform = gameObject.transform;
				var centerUV : Rectangle = new Rectangle( 
					imageUVRect.x + ( ( scale9Rect.left / width ) * imageUVRect.width ),
					imageUVRect.y + ( ( scale9Rect.top / height ) * imageUVRect.height ),
					( scale9Rect.width / width ) * imageUVRect.width,
					( scale9Rect.height / height ) * imageUVRect.height
				);
				var uvRect : Rectangle = new Rectangle();
				var vertexData : Array<Float> = [];
				
				var lostWidth = scaledWidth - ((scale9Rect.width * t.scaleX) + scale9Rect.x + (width - scale9Rect.right));
				var lostHeight = scaledHeight - ((scale9Rect.height * t.scaleY) + scale9Rect.y + (height - scale9Rect.bottom));
				var extraScaleX = (scale9Rect.width + (lostWidth / t.scaleX)) / scale9Rect.width;
				var extraScaleY = (scale9Rect.height + (lostHeight / t.scaleY)) / scale9Rect.height;
				
				// top left
				var m = new Matrix3();
				
				m.identity();
				m.translate( -t.anchorX, -t.anchorY );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect.setTo( imageUVRect.x, imageUVRect.y, centerUV.left, centerUV.top );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				// top center
				m.identity();
				m.translate( -t.anchorX, -t.anchorY );
				m.scale( t.scaleX * extraScaleX, 1 );
				m.translate( scale9Rect.x, 0 );
				m.rotate( t.rotation );
				m.translate( t.x , t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect = new Rectangle( centerUV.left, imageUVRect.y, centerUV.width, centerUV.top );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				// top right
				m.identity();
				m.translate( -t.anchorX + scale9Rect.left + (scale9Rect.width * extraScaleX * t.scaleX), -t.anchorY );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect = new Rectangle( centerUV.right, imageUVRect.top, imageUVRect.right - centerUV.right, centerUV.top );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				
				// center left
				m.identity();
				m.translate( -t.anchorX, -t.anchorY );
				m.scale( 1, t.scaleY * extraScaleY );
				m.translate( 0, scale9Rect.y );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect.setTo( imageUVRect.x, centerUV.top, centerUV.left, centerUV.height );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				
				// center
				m.identity();
				m.translate( -t.anchorX, -t.anchorY );
				m.scale( t.scaleX * extraScaleX, t.scaleY * extraScaleY );
				m.translate( scale9Rect.x, scale9Rect.y );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, centerUV, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				// center right
				m.identity();
				m.translate( -t.anchorX, -t.anchorY );
				m.scale( 1, t.scaleY * extraScaleY );
				m.translate( -t.anchorX + scale9Rect.left + (scale9Rect.width * extraScaleX * t.scaleX), scale9Rect.y );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect.setTo( centerUV.right, centerUV.top, imageUVRect.right - centerUV.right, centerUV.height );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				
				// bottom left
				m.identity();
				m.translate( -t.anchorX, -t.anchorY + scale9Rect.top + (scale9Rect.height * extraScaleY * t.scaleY) );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect.setTo( imageUVRect.x, centerUV.bottom, centerUV.left, imageUVRect.bottom - centerUV.bottom );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				
				// bottom center
				m.identity();
				m.translate( -t.anchorX, -t.anchorY );
				m.scale( t.scaleX * extraScaleX, 1 );
				m.translate( scale9Rect.x, scale9Rect.top + (scale9Rect.height * extraScaleY * t.scaleY) );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect.setTo( centerUV.x, centerUV.bottom, centerUV.width, imageUVRect.bottom - centerUV.bottom );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				// bottom right
				m.identity();
				m.translate( -t.anchorX + scale9Rect.left + (scale9Rect.width * extraScaleX * t.scaleX), -t.anchorY + scale9Rect.top + (scale9Rect.height * extraScaleY * t.scaleY) );
				m.rotate( t.rotation );
				m.translate( t.x, t.y );
				if ( t.parent != null && !t.parent.isRoot ) m.concat( t.parent.renderMatrix );
				uvRect.setTo( centerUV.right, centerUV.bottom, imageUVRect.right - centerUV.right, imageUVRect.bottom - centerUV.bottom );
				vertexData = vertexData.concat( canvas.buildTexturedQuadVertexData( texture, uvRect, m, color.r, color.g, color.b, color.a * getCompositeAlpha() ) );
				
				
				var indices : Array<Int> = [];
				
				for ( s in 0...9 ) {
					for ( i in Canvas.QUAD_INDICES ) {
						indices.push( (4 * s) + i );
					}
				}
				
				canvas.draw( _textureArray, ImageRenderer.defaultShader, vertexData, indices );
				
			}
		}
	}
}