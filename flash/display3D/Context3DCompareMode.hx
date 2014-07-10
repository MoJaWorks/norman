/****
* 
****/

package flash.display3D;
#if (flash || display)
@:fakeEnum(String) extern enum Context3DCompareMode {
	ALWAYS;
	EQUAL;
	GREATER;
	GREATER_EQUAL;
	LESS;
	LESS_EQUAL;
	NEVER;
	NOT_EQUAL;
}
 #end