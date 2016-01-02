package uk.co.mojaworks.norman.systems.audio;
import lime.Assets;
import lime.audio.AudioBuffer;
import lime.audio.AudioSource;

/**
 * ...
 * @author Simon
 */

enum AudioType {
	Music;
	SFX;
	LoopingSFX;
}
 
class AudioInstance
{

	public static var _autoInstanceId : Int = 0;
	
	public var source : AudioSource;
	public var buffer : AudioBuffer;
	public var resourceId : String;
	public var instanceId : Int;
	public var volume( default, set ) : Float;
	public var type : AudioType;
	
	public function new( resourceId : String, volume : Float, type : AudioType ) 
	{
		this.instanceId = _autoInstanceId++;
		this.resourceId = resourceId;
		this.buffer = Assets.getAudioBuffer( resourceId );
		this.source = new AudioSource( buffer );	
		this.volume = volume;
		this.type = type;
	}
	
	private function set_volume( val : Float ) : Float 
	{
		this.volume = val;
		updateVolume();
		return val;
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
	
}