package uk.co.mojaworks.norman.core.controller;

/**
 * @author Simon
 */

interface ICommand 
{
	function execute( data : Dynamic = null ) : Void;
}