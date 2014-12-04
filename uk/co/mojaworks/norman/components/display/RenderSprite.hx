package uk.co.mojaworks.norman.components.display;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageFragmentShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageVertexShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.utils.Color;

/**
 * Renders to a texture so can be used to cache large collections or draw them elsewhere
 * @author ...
 */
class RenderSprite extends Sprite
{

	var _target : ITextureData;
	var _dirty : Bool = true;
	var _isCleaning : Bool = false;
	var _width : Float = 100;
	var _height : Float = 100;
	
	public var color( default, set ) : Color = 0xFFFFFFFF;
	public var width( get, set ) : Float;
	public var height( get, set ) : Float;
	
	public function new() 
	{
		super();		
	}
		
	override public function getShader():IShaderProgram 
	{
		return ImageSprite.shader;
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		gameObject.transform.isRoot = true;
		updateCache();
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		gameObject.transform.isRoot = false;
		core.app.renderer.destroyTexture( _target.id );
	}
		
	public function updateCache() : Void {
		_dirty = true;
		
		if ( _target != null ) core.app.renderer.destroyTexture( _target.id );
		_target = core.app.renderer.createTexture( "@norman/rendertexture/" + gameObject.id, Std.int(_width), Std.int(_height) );
	}
	
	public function setSize( width : Float, height : Float ) : RenderSprite {
		if ( _width != width || _height != height ) {
			_width = width;
			_height = height;
			updateCache();
		}
		
		return this;
	}
	
	// Getters and setters
	private function set_width( width : Float ) : Float { 
		if ( this.width != _width ) {
			_width = width;
			updateCache();
		}
		return width; 
	}
	
	private function set_height( height : Float ) : Float {
		if ( this.height != _height ) {
			_height = height;
			updateCache();
		}
		return height; 
	}
	
	private function get_width() : Float { return _width; }
	private function get_height() : Float { return _height; }
	
	private function set_color( color : Color ) : Color { 
		if ( color != this.color ) {
			this.color = color;
			_dirty = true;
		}
		return color;
	}
	
	/**
	 * Render
	 */
	
	override public function preRender( canvas:ICanvas ) : Bool 
	{
		
		if ( _dirty && super.preRender(canvas) ) {
			//trace("Doing full render");
			canvas.pushRenderTarget( _target );
			canvas.clear(0, 0, 0, 0);
			_isCleaning = true;
			return true;
		}
		
		return false;
	}
	
	
	override public function postRender(canvas:ICanvas):Void 
	{
		super.postRender(canvas);
		if ( _dirty && _isCleaning ) {
			canvas.popRenderTarget();
			_dirty = false;
		}
		
		if ( visible ) canvas.drawImage( _target, renderTransform, getShader(), color.r, color.g, color.b, color.a * getFinalAlpha() );
			
	}
	
	override public function getNaturalWidth():Float 
	{
		return _width;
	}
	
	override public function getNaturalHeight():Float 
	{
		return _height;
	}
	
}