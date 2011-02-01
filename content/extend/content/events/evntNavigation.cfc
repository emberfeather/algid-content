component extends="algid.inc.resource.base.event" {
	/**
	 * Remove the cached navigation after the positioning.
	 */
	public void function afterPosition( required struct transport, required component currUser, required component path, required array positions ) {
		var cache = '';
		var cacheManager = '';
		
		// Remove all cached navigation for the entire domain
		cacheManager = arguments.transport.theApplication.managers.plugin.getContent().getCache();
		
		cache = cacheManager.getNavigation();
		
		// TODO Only clear the navigation for the affected domain
		cache.clear();
	}
}
