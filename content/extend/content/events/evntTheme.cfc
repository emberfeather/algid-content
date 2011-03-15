component extends="algid.inc.resource.base.event" {
	public void function afterArchive( required struct transport, required component theme ) {
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully archived.');
	}
	
	public void function afterCreate( required struct transport, required component theme ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('content', 'createTheme', 'Created the ''' & arguments.theme.getTheme() & ''' theme.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.theme.getThemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully created.');
	}
	
	public void function afterUnarchive( required struct transport, required component theme ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('content', 'unarchiveTheme', 'Unarchived the ''' & arguments.theme.getTheme() & ''' theme.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.theme.getThemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully unarchived.');
	}
	
	public void function afterUpdate( required struct transport, required component theme ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('content', 'updateTheme', 'Updated the ''' & arguments.theme.getTheme() & ''' theme.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.theme.getThemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & arguments.theme.getTheme() & ''' was successfully updated.');
	}
}
