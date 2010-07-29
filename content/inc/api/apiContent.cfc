component extends="plugins.api.inc.resource.base.api" {
	public component function searchPath() {
		var i = '';
		var filter = {};
		var servContent = '';
		var results = '';
		
		// Validate required arguments
		if( !structKeyExists(variables.apiRequestBody, 'path') ) {
			throw('validation', 'Missing search path', 'The search requires a path');
		}
		
		filter.searchPath = variables.apiRequestBody.path;
		
		servContent = variables.services.get('widget', 'widget');
		
		// Retrieve the search results
		variables.apiResponseBody = servContent.getPaths( filter );
		
		// Send back some of the request
		variables.apiResponseHead['path'] = variables.apiRequestBody.path;
		
		return getApiResponse();
	}
}
