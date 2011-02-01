component extends="algid.inc.resource.base.event" {
	public void function afterArchive( required struct transport, required component currUser, required component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainArchive', 'Archived the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The domain ''' & arguments.domain.getDomain() & ''' was successfully removed.');
	}
	
	public void function afterCreate( required struct transport, required component currUser, required component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainCreate', 'Created the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The domain ''' & arguments.domain.getDomain() & ''' was successfully created.');
	}
	
	public void function afterUnarchive( required struct transport, required component currUser, required component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainUnarchive', 'Unarchived the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The domain ''' & arguments.domain.getDomain() & ''' was successfully unarchived.');
	}
	
	public void function afterUpdate( required struct transport, required component currUser, required component domain ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'domainUpdate', 'Updated the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The domain ''' & arguments.domain.getDomain() & ''' was successfully updated.');
	}
}
