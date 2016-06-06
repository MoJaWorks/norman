package uk.co.mojaworks.norman.core.io;
import geoff.event.Key;
import geoff.utils.LinkedList;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
import uk.co.mojaworks.norman.components.io.IKeyboardDelegate;

/**
 * ...
 * @author Simon
 */
class KeyboardInput
{

	var _keyboardDelegates : LinkedList<IKeyboardDelegate>;
	
	public var keyState : Map<String,Bool>;
	public var keyUp : Signal2<Int, Int>;
	public var keyDown : Signal2<Int, Int>;
	public var textEntered : Signal1<String>;
	public var textEditing : Signal1<String>;
	
	public function new() 
	{
		_keyboardDelegates = new LinkedList<IKeyboardDelegate>( );
		keyState = new Map<String,Bool>();
		keyUp = new Signal2<Int, Int>();
		keyDown = new Signal2<Int, Int>();
		textEntered = new Signal1<String>();
		textEditing = new Signal1<String>();
	}
	
	/**
	 * Keyboard
	 */
	
	public function addKeyboardDelegate( kb : IKeyboardDelegate ) : Void 
	{
		_keyboardDelegates.push( kb );
	}
	
	public function removeKeyboardDelegate( kb : IKeyboardDelegate ) : Void 
	{
		_keyboardDelegates.remove( kb );
	}
		
	public function isKeyDown( key : Int ) : Bool
	{
		var key_str : String = Std.string( key );
		
		if ( keyState.exists( key_str ) )
		{
			return keyState.get( key_str );
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * Get input from system events
	 */
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	public function onKeyUp( key : Int, modifier : Int ) : Void {
		keyState.set( Std.string(key), false );
		keyUp.dispatch( key, modifier );
		for ( kb in _keyboardDelegates ) if ( kb.enabled ) kb.onKeyUp( key, modifier );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	public function onKeyDown( key : Int, modifier : Int ) : Void {
		keyState.set( Std.string(key), true );
		keyDown.dispatch( key, modifier );
		for ( kb in _keyboardDelegates ) if ( kb.enabled ) kb.onKeyDown( key, modifier );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onTextEntry( str : String ) : Void {
		textEntered.dispatch( str );
		for ( kb in _keyboardDelegates ) if ( kb.enabled ) kb.onTextEntry( str );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onTextEdit( str : String ) : Void {
		textEditing.dispatch( str );
		for ( kb in _keyboardDelegates ) if ( kb.enabled ) kb.onTextEdit( str );
	}
	
	
}