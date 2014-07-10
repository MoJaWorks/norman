/****
* 
****/

package flash.display3D;
#if (flash || display)
@:final extern class Program3D {
	function dispose() : Void;
	function upload(vertexProgram : flash.utils.ByteArray, fragmentProgram : flash.utils.ByteArray) : Void;
}
#end