component extends="plugins.api.inc.resource.base.api" {
	public component function searchPath(required string path) {
		var i = '';
		var filter = {};
		var servPath = '';
		var results = '';
		
		servPath = variables.services.get('content', 'path');
		
		filter.searchPath = variables.apiRequestBody.path;
		filter.orderBy = 'path';
		
		// Retrieve the search results
		variables.apiResponseBody = servPath.getPaths( filter );
		
		// Send back some of the request
		variables.apiResponseHead['path'] = variables.apiRequestBody.path;
		
		return getApiResponse();
	}
}
