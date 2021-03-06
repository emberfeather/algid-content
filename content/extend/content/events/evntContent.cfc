component extends="algid.inc.resource.base.event" {
	public void function afterArchive( required struct transport, required component content ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		local.eventLog.logEvent('content', 'contentArchive', 'Archived the ''' & arguments.content.getTitle() & ''' content.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.content.getContentID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The ''' & arguments.content.getTitle() & ''' content was successfully archived.');
	}
	
	public void function afterCacheClear( required struct transport ) {
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('Content cache cleared successfully.');
	}
	
	public void function afterCacheKeyDelete( required struct transport, required string key ) {
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('Deleted the content cache ''' & arguments.key & ''' key successfully.');
	}
	
	public void function afterCreate( required struct transport, required component content ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		local.eventLog.logEvent('content', 'contentCreate', 'Created the ''' & arguments.content.getTitle() & ''' content.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.content.getContentID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The ''' & arguments.content.getTitle() & ''' content was successfully created.');
	}
	
	public void function afterPublish( required struct transport, required component content ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		local.eventLog.logEvent('content', 'contentPublish', 'Published the ''' & arguments.content.getTitle() & ''' content.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.content.getContentID());
	}
	
	/**
	 * Remove the cached paths after the save including paths removed from the content.
	 */
	public void function afterSave( required struct transport, required component content ) {
		local.servDomain = getService(arguments.transport, 'content', 'domain');
		local.servContent = getService(arguments.transport, 'content', 'content');
		local.servPath = getService(arguments.transport, 'content', 'path');
		local.plugin = arguments.transport.theApplication.managers.plugin.getContent();
		
		// Get the cache for the content
		local.cacheManager = local.plugin.getCache();
		local.cache = local.cacheManager.getContent();
		
		// Find the domain for the content
		local.domain = local.servDomain.getDomain( arguments.content.getDomainID() );
		local.hosts = local.domain.getHosts();
		
		// Get the paths from the content
		local.paths = local.servPath.getPaths({ contentID: arguments.content.getContentID() });
		
		// Clear the cache key for each path for the content, including removed paths
		for( local.i = 1; local.i <= arrayLen(local.hosts); local.i++ ) {
			for( local.j = 1; local.j <= local.paths.recordCount; local.j++ ) {
				local.cache.delete( local.hosts[local.i].getHostName() & local.paths.path[local.j] );
			}
		}
		
		// Update the sitemap.xml for the domain
		local.servContent.generateSitemap(local.domain);
	}
	
	public void function afterUpdate( required struct transport, required component content ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		local.eventLog.logEvent('content', 'contentUpdate', 'Updated the ''' & arguments.content.getTitle() & ''' content.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.content.getContentID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The ''' & arguments.content.getTitle() & ''' content was successfully updated.');
	}
	
	/**
	 * Remove the cached paths before the archive including paths removed from the content.
	 */
	public void function beforeArchive( required struct transport, required component content ) {
		var cache = '';
		var cacheManager = '';
		var domain = '';
		var i = '';
		var paths = '';
		var servDomain = getService(arguments.transport, 'content', 'domain');
		var servPath = getService(arguments.transport, 'content', 'path');
		
		// Get the cache for the content
		cacheManager = arguments.transport.theApplication.managers.plugin.getContent().getCache();
		cache = cacheManager.getContent();
		
		// Find the domain for the content
		domain = servDomain.getDomain( arguments.content.getDomainID() );
		
		// Get the paths from the content
		paths = servPath.getPaths({ contentID: arguments.content.getContentID() });
		
		// Clear the cache key for each path for the content, including removed paths
		for( i = 1; i <= paths.recordCount; i++ ) {
			cache.delete( domain.getDomain() & paths['path'][i].toString() );
		}
	}
}
