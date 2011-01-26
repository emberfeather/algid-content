component extends="algid.inc.resource.base.event" {
	public void function afterArchive( required struct transport, required component currUser, required component theme ) {
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully archived.');
	}
	
	public void function afterCreate( required struct transport, required component currUser, required component theme ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('content', 'createTheme', 'Created the ''' & arguments.theme.getTheme() & ''' theme.', arguments.currUser.getUserID(), arguments.theme.getThemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully created.');
	}
	
	public void function afterUnarchive( required struct transport, required component currUser, required component theme ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the unarchive event
		eventLog.logEvent('content', 'unarchiveTheme', 'Unarchived the ''' & arguments.theme.getTheme() & ''' theme.', arguments.currUser.getUserID(), arguments.theme.getThemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully unarchived.');
	}
	
	public void function afterUpdate( required struct transport, required component currUser, required component theme ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the update event
		eventLog.logEvent('content', 'updateTheme', 'Updated the ''' & arguments.theme.getTheme() & ''' theme.', arguments.currUser.getUserID(), arguments.theme.getThemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully updated.');
	}
}
