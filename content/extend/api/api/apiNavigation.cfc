component extends="plugins.api.inc.resource.base.api" {
	public component function setPositions(required string path, required array positions) {
		var filter = {};
		var paths = '';
		var servPath = '';
		var servNavigation = '';
		var results = '';
		
		servPath = variables.services.get('content', 'path');
		servDomain = variables.services.get('content', 'domain');
		servNavigation = variables.services.get('content', 'navigation');
		
		// Get the domain
		filter = {
			host: variables.transport.theCgi.server_name
		};
		
		local.domains = servDomain.getDomains(filter);
		
		if(!local.domains.recordCount) {
			throw(message = 'Unable to find domain information', detail = 'The domain was not found for #filter.host#');
		}
		
		local.domain = servDomain.getDomain(local.domains.domainID.toString());
		
		// Get the path
		filter = {
			path: arguments.path
		};
		
		paths = servPath.getPaths(filter);
		
		local.currentPath = servPath.getPath(paths.pathID.toString());
		
		// Save the positions of the navigation
		servNavigation.setPositions(local.currentPath, local.domain, arguments.positions);
		
		// Send back some of the request
		variables.apiResponseHead['path'] = variables.apiRequestBody.path;
		
		return getApiResponse();
	}
}
