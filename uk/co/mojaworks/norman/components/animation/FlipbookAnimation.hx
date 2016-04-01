package uk.co.mojaworks.norman.components.animation;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.core.renderer.TextureData;

/**
 * ...
 * @author Simon
 */
class FlipbookFrame 
{
	public var texture : TextureData;
	public var subtextureId : String;
	public var weight : Float;
	
	public function new( texture : TextureData, ?subtextureId : String = null, ?weight : Float = 1 )
	{
		this.texture = texture;
		this.subtextureId = subtextureId;
		this.weight = weight;
	}
}
 
class FlipbookAnimation extends Animation
{

	public var fps( get, set ) : Float;
	public var currentFrame( default, set ) : Int = 0;
	public var looping : Bool = false;
	
	var _timeSinceLastFrame : Float = 0;
	var _playbackRate : Float = (1/60);
	var _frames : Array<FlipbookFrame>;
	
	public function new( frames : Array<FlipbookFrame>, looping : Bool ) 
	{
		super();
		setFrames( frames );
		this.looping = looping;
	}
	
	public function setFrames( frames : Array<FlipbookFrame> ) : Void 
	{
		_frames = frames;
		currentFrame = 0;
	}
	
	override public function update(seconds:Float):Void 
	{
		super.update(seconds);
		
		_timeSinceLastFrame += seconds;
		while ( _timeSinceLastFrame > _playbackRate * _frames[currentFrame].weight )
		{
			_timeSinceLastFrame -= _playbackRate * _frames[currentFrame].weight;
			
			currentFrame++;
			if ( currentFrame >= _frames.length ) 
			{
				if ( looping ) currentFrame = 0;
				else {
					destroy();
					return;
				}
			}
			
			ImageRenderer.getFrom( gameObject ).setTexture( _frames[currentFrame].texture, _frames[currentFrame].subtextureId );
		}
		
	}
	
	private function set_fps( fps : Float ) : Float 
	{
		this._playbackRate = 1 / fps;
		return fps;
	}
	
	private function get_fps() : Float 
	{
		return 1 / _playbackRate;
	}
	
	private function set_currentFrame( frame : Int ) : Int 
	{
		this.currentFrame = frame % _frames.length;
		ImageRenderer.getFrom( gameObject ).setTexture( _frames[currentFrame].texture, _frames[currentFrame].subtextureId );
		return currentFrame;
	}
	
	
	
}