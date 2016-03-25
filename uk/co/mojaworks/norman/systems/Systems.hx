package uk.co.mojaworks.norman.systems;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem;
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