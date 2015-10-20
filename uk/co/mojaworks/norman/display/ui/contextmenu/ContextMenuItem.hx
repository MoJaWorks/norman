package uk.co.mojaworks.norman.display.ui.contextmenu;
import uk.co.mojaworks.hopper.data.ResourceData;
import uk.co.mojaworks.norman.display.FillSprite;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.display.TextSprite;
import uk.co.mojaworks.norman.display.ui.SimpleButton;
import uk.co.mojaworks.norman.systems.ui.MouseEvent;
import uk.co.mojaworks.norman.systems.ui.UIComponent;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class ContextMenuItem extends Sprite
{

	public var uiComponent : UIComponent;
	
	var data : ContextMenuItemData;
	var text : TextSprite;
	var background : FillSprite;
	
	public function new( data : ContextMenuItemData ) 
	{
		
		super();
		
		this.data = data;
		
		background = new FillSprite( Color.WHITE, 200, 40 );
		addChild( background );
		
		text = new TextSprite();
		text.font = ResourceData.LEAGUE_SPARTAN_24;
		text.fontSize = 20;
		text.x = 20;
		text.y = 10;
		text.color = Color.BLACK;
		text.text = data.label;
		addChild( text );
		
		/*uiComponent = new UIComponent( this, background );
		uiComponent.mouseOver.add( onMouseOver );
		uiComponent.mouseOut.add( onMouseOut );
		uiComponent.clicked.add( onClicked );*/
	}
	
	function onMouseOver( e : MouseEvent ) : Void
	{
		background.color = Color.BLACK;
		text.color = Color.WHITE;
	}
	
	function onMouseOut( e : MouseEvent ) : Void
	{
		background.color = Color.WHITE;
		text.color = Color.BLACK;
	}
	
	function onClicked( e : MouseEvent ) : Void
	{
		data.callback();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
			
		//uiComponent.destroy();
		text.destroy();
		background.destroy();
		
		//uiComponent = null;
		text = null;
		background = null;
		data = null;
	}
	
}