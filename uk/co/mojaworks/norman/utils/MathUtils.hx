package uk.co.mojaworks.norman.utils;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Simon
 */
class MathUtils
{

	public function new() 
	{
		
	}
	
	public static function roundToNextPow2( val : Float ) : Int {
		return Std.int( Math.pow( 2, Math.ceil( Math.log( val ) / Math.log(2) ) ) );
	}
	
	public static function transformRect( rect : Rectangle, m : Matrix ) : Void {

		var tx0 = m.a * rect.x + m.c * rect.y;
		var tx1 = tx0;
		var ty0 = m.b * rect.x + m.d * rect.y;
		var ty1 = tx0;
		
		var tx = m.a * (rect.x + rect.width) + m.c * rect.y;
		var ty = m.b * (rect.x + rect.width) + m.d * rect.y;
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		tx = m.a * (rect.x + rect.width) + m.c * (rect.y + rect.height);
		ty = m.b * (rect.x + rect.width) + m.d * (rect.y + rect.height);
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		tx = m.a * rect.x + m.c * (rect.y + rect.height);
		ty = m.b * rect.x + m.d * (rect.y + rect.height);
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		rect.x = tx0 + m.tx;
		rect.y = ty0 + m.ty;
		rect.width = tx1 - tx0;
		rect.height = ty1 - ty0;
		//return new Rectangle (tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
		
	}
	
}