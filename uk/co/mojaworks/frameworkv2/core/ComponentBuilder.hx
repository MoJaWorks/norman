package uk.co.mojaworks.frameworkv2.core;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author Simon
 */
class ComponentBuilder {
	
	macro static public function build() : Array<Field> {
		
		var fields = Context.getBuildFields();
		
		var val = Context.getLocalClass();
		var parent = val;
		
		while ( parent.get().superClass != null && parent.get().superClass.t.toString() != "uk.co.mojaworks.frameworkv2.core.Component" ) parent = parent.get().superClass.t;
			
		// If this subclasses Component
		if ( parent.get().superClass != null ) {
			
			var id : String = parent.toString();
			
			// Add a static field to the class
			var idField : Field = {
				access: [APublic, AStatic],
				name: "TYPE",
				pos: Context.currentPos(),
				kind: FVar( macro : String, Context.makeExpr(id, Context.currentPos() ) )
			}
			
			fields.push( idField );
								
			// Override the getComponentType function to return the correct value
			var idField : Field = {
				access: [APublic, AOverride],
				name: "getComponentType",
				pos: Context.currentPos(),
				kind: FFun({
					ret: macro:String,
					params: [],
					args:[],
					expr: {
						expr: EReturn( {
							expr: EConst(CString(id)),
							pos: Context.currentPos()
						}),
						pos: Context.currentPos()
					}
				})
			}
			
			fields.push( idField );

		}
		
		
		
		return fields;
	}
	
}