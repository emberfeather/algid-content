component extends="plugins.api.inc.resource.base.api" {
	public component function setPositions(required string path, required array positions) {
		var filter = {};
		var currentPath = '';
		var paths = '';
		var servPath = '';
		var servNavigation = '';
		var results = '';
		
		servPath = variables.services.get('content', 'path');
		servNavigation = variables.services.get('content', 'navigation');
		
		// Get the path
		filter = {
			path: arguments.path
		};
		
		paths = servPath.getPaths(filter);
		
		currentPath = servPath.getPath(paths.pathID.toString());
		
		// Save the positions of the navigation
		servNavigation.setPositions(currentPath, arguments.positions);
		
		// Send back some of the request
		variables.apiResponseHead['path'] = variables.apiRequestBody.path;
		
		return getApiResponse();
	}
}
