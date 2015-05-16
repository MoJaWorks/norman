package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
abstract Color( Int ) to Int from Int
{
	
	public static inline var RED : Color = 0xFFFF0000;
	public static inline var GREEN : Color = 0xFF00FF00;
	public static inline var BLUE : Color = 0xFF0000FF;
	public static inline var BLACK : Color = 0xFF000000;
	public static inline var WHITE : Color = 0xFFFFFFFF;
	public static inline var YELLOW : Color = 0xFFFFFF00;
	public static inline var PURPLE : Color = 0xFFFF00FF;
	
	
	public static inline var RATIO_255 = (1 / 255);
	
	public var r( get, set ) : Int;
	public var g( get, set ) : Int;
	public var b( get, set ) : Int;
	public var a( get, set ) : Float;
	
	public inline function new( i : Int ) {
		this = i;
	}
	
	public inline static function rgb( r : Int, g : Int, b : Int ) : Color {
		var color : Color = 0;
		color.a = 1;
		color.r = r;
		color.g = g;
		color.b = b;
		return color;
	}
	
	public inline static function rgba( r : Int, g : Int, b : Int, a : Float ) : Color {
		var color : Color = 0;
		color.a = a;
		color.r = r;
		color.g = g;
		color.b = b;
		return color;
	}
	
	private inline function get_a() : Float { return ((this & 0xFF000000) >>> 24 ) * RATIO_255; }
	private inline function get_r() : Int { return (this & 0xFF0000) >> 16; }
	private inline function get_g() : Int { return (this & 0xFF00) >> 8; }
	private inline function get_b() : Int { return (this & 0xFF); }
	
	private inline function set_a( a : Float ) : Float {
		this = (this & 0x00FFFFFF) + (Math.round(a * 255) << 24 );
		return a;
	}
	
	private inline function set_r( r : Int ) : Int {
		this = (this & 0xFF00FFFF) + (r << 16);
		return r;
	}
	
	private inline function set_g( g : Int ) : Int {
		this = (this & 0xFFFF00FF) + (g << 8);
		return g;
	}
	
	private inline function set_b( b : Int ) : Int {
		this = (this & 0xFFFFFF00) + b;
		return b;
	}
	
	
}