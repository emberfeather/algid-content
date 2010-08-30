<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/**
	 * Prevent the caching from happening if there is a content defined for the request.
	 */
	public void function addLevel( required struct transport, required string title, string navTitle = '', string link = '' ) {
		if(arguments.transport.theRequest.managers.singleton.hasTemplate()) {
			arguments.transport.theRequest.managers.singleton.getTemplate().addLevel( arguments.title, arguments.navTitle, arguments.link );
		}
	}
	
	/**
	 * Prevent the caching from happening if there is a content defined for the request.
	 */
	public void function doPreventCaching( required struct transport ) {
		if(arguments.transport.theRequest.managers.singleton.hasContent()) {
			arguments.transport.theRequest.managers.singleton.getContent().setDoCaching( false );
		}
	}
</cfscript>
</cfcomponent>
