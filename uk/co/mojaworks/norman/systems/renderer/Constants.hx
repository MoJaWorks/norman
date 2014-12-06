package uk.co.mojaworks.norman.systems.renderer;

/**
 * ...
 * @author ...
 */
#if !flash
	@:enum abstract BlendFactor(Int)
	{
		var ZERO = lime.graphics.opengl.GL.ZERO;
		var ONE = lime.graphics.opengl.GL.ONE;
		var SOURCE_COLOR = lime.graphics.opengl.GL.SRC_COLOR;
		var ONE_MINUS_SOURCE_COLOR = lime.graphics.opengl.GL.ONE_MINUS_SRC_COLOR;
		var SOURCE_ALPHA = lime.graphics.opengl.GL.SRC_ALPHA;
		var ONE_MINUS_SOURCE_ALPHA = lime.graphics.opengl.GL.ONE_MINUS_SRC_ALPHA;
		var DESTINATION_ALPHA = lime.graphics.opengl.GL.DST_ALPHA;
		var ONE_MINUS_DESTINATION_ALPHA = lime.graphics.opengl.GL.ONE_MINUS_DST_ALPHA;
		var DESTINATION_COLOR = lime.graphics.opengl.GL.DST_COLOR;
		var ONE_MINUS_DESTINATION_COLOR = lime.graphics.opengl.GL.ONE_MINUS_DST_COLOR;
	}
#else
	typedef BlendFactor = flash.display3D.Context3DBlendFactor;
#end