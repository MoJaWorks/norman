package uk.co.mojaworks.norman.systems.audio;
import lime.Assets;
import lime.audio.AudioBuffer;
import lime.audio.AudioSource;
import motion.Actuate;
import uk.co.mojaworks.norman.factory.IDisposable;

/**
 * ...
 * @author Simon
 */

enum AudioType {
	Music;
	SFX;
	LoopingSFX;
}
 
class AudioInstance implements IDisposable
{

	public static var _autoInstanceId : Int = 0;
	
	public var source : AudioSource;
	public var buffer : AudioBuffer;
	public var resourceId : String;
	public var instanceId : Int;
	public var volume( get, set ) : Float;
	public var type : AudioType;
	public var looping : Bool;
	public var destroyed : Bool = false;
	
	var _volume : Float = 1;
	
	public function new( resourceId : String, volume : Float, type : AudioType ) 
	{
		this.instanceId = _autoInstanceId++;
		this.resourceId = resourceId;
		this.buffer = Assets.getAudioBuffer( resourceId );
		this.source = new AudioSource( buffer );	
		this.volume = volume;
		this.type = type;
		this.looping = type != SFX;
	}
	
	private function set_volume( val : Float ) : Float 
	{
		_volume = val;
		updateVolume();
		return val;
	}
	
	private function get_volume( ) : Float 
	{
		return _volume;
	}
	
	
	public function updateVolume() : Void 
	{
		source.gain = volume * Systems.audio.masterVolume;
		if ( type == Music ) {
			source.gain *= Systems.audio.musicVolume;
		}else {
			source.gain *= Systems.audio.sfxVolume;
		}
	}
	
	public function destroy() 
	{
		if ( ! destroyed ) 
		{
			if ( source != null ) source.stop();
			source.dispose();
			destroyed = true;
		}
		
	}

	
}