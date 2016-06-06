package uk.co.mojaworks.norman.core.io;

/**
 * ...
 * @author Simon
 */
class AccelerometerInput
{

	//var accelerometer : Sensor;
	
	public var x( default, null ) : Float;
	public var y( default, null ) : Float;
	public var z( default, null ) : Float;
	
	public var supported( default, null ) : Bool = false;
	
	public function new() 
	{
		/*var sensors : Array<Sensor> = Sensor.getSensors( SensorType.ACCELEROMETER );
		if ( sensors.length > 0 ) 
		{
			accelerometer = sensors[0];
			accelerometer.onUpdate.add( onAccelerometerUpdate );
			supported = true;
		}*/
	}
	
	private function onAccelerometerUpdate( x : Float, y : Float, z : Float ) : Void
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
}