package uk.co.mojaworks.norman.hardware;

/**
 * ...
 * @author Simon
 */
class Vibration
{

	// External methods
	var vibrateMethod : Dynamic;
	
	public static var isSupported : Bool = false;
		
	public function new() 
	{
					
		#if android
			var supportedMethod : Dynamic = lime.system.JNI.createStaticMethod( "uk/co/mojaworks/norman/Vibration", "isSupported", "()Z" );
			isSupported = lime.system.JNI.callStatic( supportedMethod, [] );
		
			if ( isSupported ) {
				vibrateMethod = lime.system.JNI.createStaticMethod( "uk/co/mojaworks/norman/Vibration", "vibrate", "([DI)V" );
			}
		#end
				
	}
	
	
	public  function vibrate( seconds : Array<Float>, repeat : Int ) : Void {
		
		if ( isSupported ) {
			#if android
				lime.system.JNI.callStatic( vibrateMethod, [seconds, repeat] );
			#end
		}
		
	}
	
}