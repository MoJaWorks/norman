package uk.co.mojaworks.norman.systems.audio;
import haxe.Timer;
import lime.app.Event;
import lime.Assets;
import lime.audio.AudioBuffer;
import lime.audio.AudioSource;
import uk.co.mojaworks.norman.systems.audio.AudioInstance.AudioType;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class AudioSystem
{

	public var masterVolume( default, set ) : Float = 1;
	public var musicVolume( default, set ) : Float = 1;
	public var sfxVolume( default, set ) : Float = 1;
	
	var _music : AudioInstance;
	var _playingAudio : LinkedList<AudioInstance>;
	
	public function new() 
	{
		_playingAudio = new LinkedList<AudioInstance>();
	}
	
	public function playOneShotWithResourceId( id : String, volume : Float ) : Int {
		
		var instance : AudioInstance = new AudioInstance( id, volume, AudioType.SFX );
		instance.source.onComplete.add( function() {
			onSoundComplete( instance );
		});
		instance.source.play();
		_playingAudio.push( instance );
		return instance.instanceId;
		
	}
	
	public function playMusicWithResourceId( id : String, volume : Float, crossFadeLength : Float = 0 ) : Int {
		
		var startVolume : Float = ( crossFadeLength > 0 ) ? 0 : volume;
		
		var instance : AudioInstance = new AudioInstance( id, startVolume, AudioType.Music );
		instance.source.onComplete.add( function() {
			onSoundComplete( instance );
		});
		instance.source.play();
		_playingAudio.push( instance );
		
		if ( crossFadeLength > 0 ) {
			// Tween the volumes
		}else {
			// Kill the last music
		}
		
		
		return instance.instanceId;
		
	}
	
	private function set_masterVolume( val : Float ) : Float {
		
		this.masterVolume = val;
		updateSoundVolumes();
		return val;
		
	}
	
	private function set_musicVolume( val : Float ) : Float {
		
		this.musicVolume = val;
		updateSoundVolumes();
		return val;
		
	}
	
	private function set_sfxVolume( val : Float ) : Float {
		
		this.sfxVolume = val;
		updateSoundVolumes();
		return val;
		
	}
	
	private function getSoundWithId( id : Int ) : AudioInstance 
	{
		for ( sound in _playingAudio ) 
		{
			if ( sound.instanceId == id ) return sound;
		}
		return null;
	}
	
	private function updateSoundVolumes() : Void 
	{
		for ( sound in _playingAudio ) 
		{
			sound.updateVolume();
		}
	}
	
	private function onSoundComplete( instance : AudioInstance ) : Void {
		// TODO: loop music or looping sounds or kill sfx
	}
	
}