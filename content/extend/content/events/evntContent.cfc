<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/* required transport */
	/* required currUser */
	/* required content */
	public void function afterArchive( struct transport, component currUser, component content ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'contentArchive', 'Archived the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID());
	}
	
	/* required transport */
	/* required currUser */
	/* required content */
	public void function afterCreate( struct transport, component currUser, component content ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'contentCreate', 'Created the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID());
	}
	
	/* required transport */
	/* required currUser */
	/* required content */
	public void function afterPublish( struct transport, component currUser, component content ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('content', 'contentPublish', 'Published the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID());
	}
	
	/**
	 * Remove the cached paths after the save including paths removed from the content.
	 */
	/* required transport */
	/* required currUser */
	/* required content */
	public void function afterSave( struct transport, component currUser, component content ) {
		var cacheContent = '';
		var domain = '';
		var i = '';
		var paths = '';
		var servDomain = arguments.transport.theApplication.factories.transient.getServDomainForContent(arguments.transport.theApplication.managers.singleton.getApplication().getDSUpdate(), arguments.transport);
		
		// Get the cache for the content
		cacheContent = arguments.transport.theApplication.managers.plugin.getContent().getCache().getContent();
		
		// Find the domain for the content
		domain = servDomain.getDomain( arguments.transport.theSession.managers.singleton.getUser(), arguments.content.getDomainID() );
		
		// Get the paths from the content
		paths = arguments.content.getPaths();
		
		// Clear the cache key for each path for the content, including removed paths
		for( i = 1; i <= arrayLen(paths); i++ ) {
			cacheContent.delete( domain.getDomain() & paths[i].getPath() )
		}
	}
	
	/* required transport */
	/* required currUser */
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
