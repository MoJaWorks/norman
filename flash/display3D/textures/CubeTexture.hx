/****
* 
****/

package flash.display3D.textures;

#if (flash || display)
@:final extern class CubeTexture extends TextureBase {
	function uploadCompressedTextureFromByteArray(data : flash.utils.ByteArray, byteArrayOffset : UInt, async : Bool = false) : Void;
	function uploadFromBitmapData(source : flash.display.BitmapData, side : UInt, miplevel : UInt = 0) : Void;
	function uploadFromByteArray(data : flash.utils.ByteArray, byteArrayOffset : UInt, side : UInt, miplevel : UInt = 0) : Void;
}
#end