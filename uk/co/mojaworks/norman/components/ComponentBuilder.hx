package uk.co.mojaworks.norman.components;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

/**
 * ...
 * @author Simon
 */
class ComponentBuilder {
	
	macro static public function build() : Array<Field> {
		
		var fields = Context.getBuildFields();
		
		var complex = TypeTools.toComplexType( Context.getLocalType() );
		var val = Context.getLocalClass();
		var parent = val;
				
		while ( parent.get().superClass != null && parent.get().superClass.t.toString() != "uk.co.mojaworks.norman.components.Component" ) parent = parent.get().superClass.t;
			
		// If this subclasses Component
		if ( parent.get().superClass != null ) {
			
			//trace("Building component type", val );
			
			var type : String = val.toString();
			var base : String = parent.toString();
			
			// Add a static field to the class
			var idField : Field = {
				access: [APublic, AStatic],
				name: "TYPE",
				pos: Context.currentPos(),
				kind: FVar( macro : String, Context.makeExpr(type, Context.currentPos() ) )
			}
			
			var baseField : Field = {
				access: [APublic, AStatic],
				name: "BASE_TYPE",
				pos: Context.currentPos(),
				kind: FVar( macro : String, Context.makeExpr(base, Context.currentPos() ) )
			}
			
			fields.push( idField );
			fields.push( baseField );
							
			// Override the getComponentType function to return the correct value
			var getFromObjectField : Field = {
				access: [APublic, AStatic],
				name: "getFromObject",
				pos: Context.currentPos(),
				kind: FFun({
					ret: complex,
					params: [],
					args:[ {name:"obj",type:macro:uk.co.mojaworks.norman.factory.GameObject}],
					expr: {
						expr: EReturn( {
							expr: Context.parse( "cast obj.getComponent(TYPE)", Context.currentPos() ).expr,
							pos: Context.currentPos()
						}),
						pos: Context.currentPos()
					}
				})
			}
			
			// Override the getComponentType function to return the correct value
			var getIdField : Field = {
				access: [APublic, AOverride],
				name: "getComponentType",
				pos: Context.currentPos(),
				kind: FFun({
					ret: macro:String,
					params: [],
					args:[],
					expr: {
						expr: EReturn( {
							expr: EConst(CString(type)),
							pos: Context.currentPos()
						}),
						pos: Context.currentPos()
					}
				})
			}
			
			// Override the getComponentType function to return the correct value
			var getBaseField : Field = {
				access: [APublic, AOverride],
				name: "getBaseComponentType",
				pos: Context.currentPos(),
				kind: FFun({
					ret: macro:String,
					params: [],
					args:[],
					expr: {
						expr: EReturn( {
							expr: EConst(CString(base)),
							pos: Context.currentPos()
						}),
						pos: Context.currentPos()
					}
				})
			}
			
			fields.push( getIdField );
			fields.push( getBaseField );
			fields.push( getFromObjectField );

		}
		
		
		
		return fields;
	}
	
}