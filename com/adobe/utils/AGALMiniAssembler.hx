package com.adobe.utils;

/**
 * ...
 * @author Simon
 */

#if ( display || flash )
 
extern class AGALMiniAssembler
{
	
	public var agalcode : flash.utils.ByteArray;
	public var error : String;
	public var verbose : Bool;
	
	public function new( debugging : Bool = false );
	public function assemble( mode : String, source : String, version : Int = 1 ) : flash.utils.ByteArray;
	public function assemble2( ctx3d:flash.display3D.Context3D, version : Int, vertexSrc : String, fragmentSrc : String ) : flash.display3D.Program3D;
}

#end