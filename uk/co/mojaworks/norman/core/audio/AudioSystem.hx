package uk.co.mojaworks.norman.core.audio;
import geoff.App;
import geoff.audio.AudioChannel;
import geoff.utils.LinkedList;
import motion.Actuate;
import uk.co.mojaworks.norman.core.audio.AudioInstance.AudioType;

/**
 * ...
 * @author Simon
 */
class AudioSystem
{

	public var masterVolume( get, set ) : Float;
	public var musicVolume( get, set ) : Float;
	public var sfxVolume( get, set ) : Float;
	
	var _masterVolume : Float = 1;
	var _musicVolume : Float = 1;
	var _sfxVolume : Float = 1;
	
	var _music : AudioInstance;
	var _playingAudio : LinkedList<AudioInstance>;
	
	public function new() 
	{
		_playingAudio = new LinkedList<AudioInstance>();
	}
	
	public function loadAsset( id : String, asset : String )
	{
		App.current.platform.audio.loadAsset( id, asset );
	}
	
	public function playOneShot( id : String, volume : Float = 1 ) : Int {
		
		
		var channel : AudioChannel = App.current.platform.audio.playOneShot( id, volume );		
		var instance : AudioInstance = new AudioInstance( channel, AudioType.SFX );
		instance.volume = volume;
		_playingAudio.push( instance );
		return instance.instanceId;
		
	}
	
	public function playLooping( id : String, volume : Float = 1 ) : Int {
		
		var channel : AudioChannel = App.current.platform.audio.playLooping( id, volume );
		var instance : AudioInstance = new AudioInstance( channel, AudioType.LoopingSFX );
		instance.volume = volume;
		_playingAudio.push( instance );
		return instance.instanceId;
		
	}
	
	public function playMusic( id : String, volume : Float = 1, crossFadeLength : Float = 0 ) : Int {
		
		var startVolume : Float = ( crossFadeLength > 0 ) ? 0 : volume;
		
		var channel : AudioChannel = App.current.platform.audio.playLooping( id, startVolume );
		var instance : AudioInstance = new AudioInstance( channel, AudioType.Music );
		instance.volume = startVolume;
		_playingAudio.push( instance );
				
		if ( crossFadeLength > 0 ) {
			// Tween the volumes
			var _currentMusic : AudioInstance = _music;
					
			instance.volume = 0;
			Actuate.tween( instance, crossFadeLength, { volume: volume } );
			if ( _currentMusic != null ) {
				Actuate.tween( _music, crossFadeLength, { volume: 0 } ).onComplete( function() {
					_currentMusic.destroy();
					_playingAudio.remove( _currentMusic );
				});
			}
			
		}else {
			if ( _music != null ) {
				_music.destroy();
				_playingAudio.remove( _music );
			}
		}
		
		_music = instance;
		
		return instance.instanceId;
		
	}
	
	
	public function update( seconds : Float ) : Void
	{
		for ( sound in _playingAudio ) 
		{
			if ( sound.channel.complete )
			{
				_playingAudio.remove( sound );
			}
		}
	}
	
	
	private function set_masterVolume( val : Float ) : Float {
		
		_masterVolume = val;
		updateSoundVolumes();
		return val;
		
	}
	
	private function set_musicVolume( val : Float ) : Float {
		
		_musicVolume = val;
		updateSoundVolumes();
		return val;
		
	}
	
	private function set_sfxVolume( val : Float ) : Float {
		
		_sfxVolume = val;
		updateSoundVolumes();
		return val;
		
	}
	
	private function get_masterVolume() : Float { return _masterVolume; };
	private function get_musicVolume() : Float { return _musicVolume; };
	private function get_sfxVolume() : Float { return _sfxVolume; };
		
	private function updateSoundVolumes() : Void 
	{
		for ( sound in _playingAudio ) 
		{
			sound.updateVolume();
		}
	}
		
	public function pauseAll() : Void {
		
		for ( sound in _playingAudio ) {
			sound.channel.paused = true;
		}
		
	}
	
	public function resumeAll() : Void {
		
		for ( sound in _playingAudio ) {
			sound.channel.paused = false;
		}
		
	}
	
	public function stopAll() : Void {
		
		for ( sound in _playingAudio ) {
			sound.destroy();
		}
		
		_playingAudio.clear();
		
	}
	
	public function stopAllWithResourceId( resourceId : String ) : Void {
		
		for ( sound in _playingAudio ) {
			if ( sound.channel.source.assetId == resourceId ) {
				sound.destroy();
				_playingAudio.remove( sound );
			}
		}
		
	}
	
	
	/**
	 * Single instance stuff
	 */
	
	
	public function pause( id : Int ) : Void {
		
		for ( sound in _playingAudio ) {
			if ( sound.instanceId == id ) sound.channel.paused = true;
		}
		
	}
	
	public function resume( id : Int ) : Void {
		
		for ( sound in _playingAudio ) {
			if ( sound.instanceId == id ) sound.channel.paused = false;
		}
		
	}
	
	public function stop( id : Int ) : Void {
		
		for ( sound in _playingAudio ) {
			if ( sound.instanceId == id ) {
				sound.destroy();
				_playingAudio.remove( sound );
			}
		}
	}
}