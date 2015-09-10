package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.display.Sprite;

/**
 * ...
 * @author Simon
 */
class Screen extends Sprite
{

	// Active controls animations and if the screen should be "alive"
	public var active( default, set ) : Bool = false;
	
	// Enabled sets whether buttons should be accessible etc
	public var enabled( default, set ) : Bool = false;
	
	var _showHideScript : Int = 0;
	
	public function new() 
	{
		super();
		
		build();
		
		visible = false;
		active = false;
		enabled = false;
	}
	
	private function build() : Void {
		
	}
	
	public function update( seconds:Float ) : Void 
	{
		// Override
	}
	
	public function resize( ) : Void {
		// Override
	}
	
	public function show( delay : Float = 0 ) : Void {
		
		visible = true;
		active = true;
		animateIn( delay );
		
	}
	
	public function animateIn( delay : Float ) : Void {
		
		onShown();
		
	}
	
	public function onShown() : Void {
		enabled = true;
	}
	
	public function hide() : Void {
		
		enabled = false;
		onHidden();
		
	}
	
	public function onHidden() : Void {
		visible = false;
		active = false;
	}
	
	public function set_active( bool : Bool ) : Bool {
		return this.active = bool;
	}
	
	public function set_enabled( bool : Bool ) : Bool {
		return this.enabled = bool;
	}
	
	public function hideAndDestroy() : Void {
		
		enabled = false;
		destroy();
		
	}
	
}