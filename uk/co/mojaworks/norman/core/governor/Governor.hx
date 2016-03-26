package uk.co.mojaworks.norman.core.governor;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class Governor
{

	var subjects : LinkedList<IGovernable>;
	
	public function new() 
	{
		subjects = new LinkedList<IGovernable>();
	}
	
	public function addSubject( subject : IGovernable, id : String, priority : Int ) : Void 
	{
		subject.priority = priority;
		subject.id = id;
		subjects.push( subject );
		
		subjects.sort( function( a, b ) : Int {
			if ( a.priority > b.priority ) return 1;
			if ( b.priority > a.priority ) return -1;
			return 0;
		});
		
	}
	
	public function removeSubject( subject : IGovernable ) : Void 
	{
		subjects.remove( subject );                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
	}
	
	public function removeSubjectById( subjectId : String ) : Void 
	{
		subjects.remove( getSubjectById( subjectId ) );
	}
	
	public function getSubjectById( subjectId : String ) : IGovernable 
	{
		for ( subject in subjects ) 
		{
			if ( subject.id == subjectId ) return subject;
		}
		
		return null;
	}
	
	public function update( seconds : Float ) : Void 
	{
		for ( subject in subjects ) 
		{
			subject.update( seconds );
		}
	}
	
	
	
}