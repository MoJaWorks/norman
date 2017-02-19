package uk.co.mojaworks.norman.systems;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.core.governor.IGovernable;
import uk.co.mojaworks.norman.factory.CoreObject;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem;
import uk.co.mojaworks.norman.systems.director.Director;
import uk.co.mojaworks.norman.systems.script.ScriptRunner;
import uk.co.mojaworks.norman.systems.ui.UISystem;

/**
 * ...
 * @author Simon
 */
@:enum abstract DefaultSystem(String) from String to String
{
	var Animation = "internal_Animation";
	var Director = "internal_Director";
	var Scripting = "internal_Scripting";
	var UI = "internal_UI";
}
 
class Systems
{
	
	/**
	 * Helper function to quickly get default systems
	 **/
	
	public static var animation( get, never ) : AnimationSystem;
	private static function get_animation() : AnimationSystem 
	{
		return cast Core.instance.governor.getSubjectById( DefaultSystem.Animation );
	}
	
	public static var director( get, never ) : Director;
	private static function get_director() : Director 
	{
		return cast Core.instance.governor.getSubjectById( DefaultSystem.Director );
	}
	
	public static var scripting( get, never ) : ScriptRunner;
	private static function get_scripting() : ScriptRunner 
	{
		return cast Core.instance.governor.getSubjectById( DefaultSystem.Scripting );
	}
	
	public static var ui( get, never ) : UISystem;
	private static function get_ui() : UISystem 
	{
		return cast Core.instance.governor.getSubjectById( DefaultSystem.UI );
	}
	
}	


/**
 * Subsystem type
 **/

class SubSystem extends CoreObject implements IGovernable
{

	public var priority : Int;	
	public var id : String;

	public function new( ) 
	{
		super();
	}
	
	public function update( seconds : Float ) : Void 
	{
		
	}
	
}

class ComponentSystem<T:Component> extends SubSystem
{
	private var _targets : Array<T>;
	
	public function new( ) 
	{
		super();
		_targets = [];
	}
	
	public function addTarget( target : T ) : T
	{
		_targets.push( target );
		return target;
	}
	
	public function removeTarget( target : T ) : T
	{
		_targets.remove( target );
		return target;
	}
}
	
	
