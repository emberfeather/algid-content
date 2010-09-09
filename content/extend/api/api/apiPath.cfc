component extends="plugins.api.inc.resource.base.api" {
	public component function renamePath(required string pathID, required string title) {
		var i = '';
		var filter = {};
		var servPath = '';
		var results = '';
		var user = '';
		
		servPath = variables.services.get('content', 'path');
		user = variables.transport.theSession.managers.singleton.getUser();
		
		path = servPath.getPath(user, variables.apiRequestBody.pathID);
		
		if(path.getPathID() eq '') {
			throw('validation', 'Path does not exist', 'Path given to rename either does not exist or you have no access.');
		}
		
		path.setTitle(variables.apiRequestBody.title);
		
		servPath.setPath(user, path);
		
		// Send back some of the request
		variables.apiResponseHead['pathID'] = variables.apiRequestBody.pathID;
		variables.apiResponseHead['title'] = path.getTitle();
		
		return getApiResponse();
	}
	
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
