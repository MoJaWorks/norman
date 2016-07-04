package uk.co.mojaworks.norman.core.audio;
import geoff.App;
import geoff.audio.AudioChannel;
import geoff.audio.AudioSource;
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

	private static var _autoInstanceId : Int = 0;
	
	public var channel : AudioChannel;
	public var volume( get, set ) : Float;
	public var type : AudioType;
	public var destroyed : Bool = false;
	public var instanceId : Int;
	
	var _volume : Float = 1;
	
	public function new( channel : AudioChannel, type : AudioType ) 
	{
		this.instanceId = _autoInstanceId++;
		this.channel = channel;
		this.volume = channel.volume;
		this.type = type;
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
		channel.volume = volume * Core.instance.audio.masterVolume;
		if ( type == Music ) {
			channel.volume *= Core.instance.audio.musicVolume;
		}else {
			channel.volume *= Core.instance.audio.sfxVolume;
		}
	}
	
	public function destroy() 
	{
		if ( ! destroyed ) 
		{
			if ( channel != null ) App.current.platform.audio.stopChannel( channel );
			destroyed = true;
		}
		
	}

	
}