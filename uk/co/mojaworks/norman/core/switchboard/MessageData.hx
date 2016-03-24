package uk.co.mojaworks.norman.core.switchboard;

/**
 * ...
 * @author Simon
 */
class MessageData {
	
	public var message : String;
	public var data : Dynamic;
	
	public function new ( message : String, data : Dynamic = null ) {
		this.data = data;
		this.message = message;
	}
}
