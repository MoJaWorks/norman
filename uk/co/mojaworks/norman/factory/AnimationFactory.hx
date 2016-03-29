package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.animation.FlipbookAnimation;
import uk.co.mojaworks.norman.components.animation.FlipbookAnimation.FlipbookFrame;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;

/**
 * ...
 * @author Simon
 */
class AnimationFactory
{

	public static function createFlipbookAnimation( frames : Array<FlipbookFrame>, looping : Bool, ?name : String ) : GameObject
	{
		var gameObject : GameObject = SpriteFactory.createImageSprite( frames[0].texture, frames[0].subtextureId, name );
		gameObject.add( new FlipbookAnimation( frames, looping ) );
		return gameObject;
	}
	
}