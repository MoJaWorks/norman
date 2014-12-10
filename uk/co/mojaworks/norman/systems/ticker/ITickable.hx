package uk.co.mojaworks.norman.systems.ticker;

/**
 * @author Simon
 */

interface ITickable 
{
	function onUpdate( seconds : Float ) : Void;
}