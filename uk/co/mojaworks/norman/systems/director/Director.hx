package uk.co.mojaworks.norman.systems.director;

/**
 * ...
 * @author Simon
 */
class Director
{

	var _currentScreen : Screen = null;
	var _currentTransition : Transition = null;
	
	var _screens : Map<String,Screen>;
	var displayStack : Array<Screen>;
	
	public function new() 
	{
		_screens = new Map<String,Screen>();
	}
	
	public function addScreen( screen : Screen, id : String ) : Void {
		_screens.set( id, screen );
		screen.active = false;
		screen.visible = false;
		screen.enabled = false;
	}
	
	public function removeScreen( id : String ) : Void {
		_screens.remove( id );
	}
	
	public function getScreen( id : String ) : Screen {
		return _screens.get(id);
	}
	
	
	public function moveToScreen( id : String, transition : Transition = null, delay : Float = 0 ) : Void {
		
		var screen : Screen = _screens.get( id );
		
		if ( transition == null ) transition = new Transition();
		transition.transition( screen, _currentScreen, delay );
		
		_currentScreen = screen;
		_currentTransition = transition; 
	}
	
	public function update( seconds : Float ) : Void 
	{
		if ( _currentScreen != null ) _currentScreen.update( seconds );
	}
	
	public function resize() : Void {
		for ( screen in _screens ) {
			screen.resize();
		}
	}
		
}