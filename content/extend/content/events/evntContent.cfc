<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/* required content */
	public void function afterArchive( struct transport, component currUser, component content ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'contentArchive', 'Archived the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID());
	}
	
	/* required content */
	public void function afterCreate( struct transport, component currUser, component content ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'contentCreate', 'Created the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID());
	}
	
	/* required content */
	public void function afterPublish( struct transport, component currUser, component content ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		
		eventLog.logEvent('content', 'contentPublish', 'Published the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID());
	}
	
	/* required content */
	public void function afterUpdate( struct transport, component currUser, component content ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'contentUpdate', 'Updated the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID());
	}
</cfscript>
</cfcomponent>
