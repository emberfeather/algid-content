<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/* required content */
	public void function afterArchive( struct transport, component currUser, component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainArchive', 'Archived the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
	}
	
	/* required content */
	public void function afterCreate( struct transport, component currUser, component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainCreate', 'Created the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
	}
	
	/* required content */
	public void function afterUnarchive( struct transport, component currUser, component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainUnarchive', 'Unarchived the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
	}
	
	/* required content */
	public void function afterUpdate( struct transport, component currUser, component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainUpdate', 'Updated the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
	}
</cfscript>
</cfcomponent>
