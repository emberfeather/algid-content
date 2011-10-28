component {
	public component function init() {
		variables.validPathChars = '/a-zA-Z0-9\._~$@&%+\!\*"''\(\),-';
		
		return this;
	}
	
	public string function clean( required string value, struct options = {} ) {
		arguments.value = trim(arguments.value);
		
		// Convert standard characters
		arguments.value = replaceList(arguments.value, '\, ','/,_');
		
		// Remove invalid characters
		arguments.value = reReplace(arguments.value, '[^' & variables.validPathChars & ']', '', 'all');
		
		// Check for path not starting with a slash
		if (not len(arguments.value) or left(arguments.value, 1) neq '/') {
			arguments.value = '/' & arguments.value;
		}
		
		// Strip repeating symbols
		arguments.value = reReplace(arguments.value, '[/]{2,}', '/', 'all');
		arguments.value = reReplace(arguments.value, '[_]{2,}', '_', 'all');
		arguments.value = reReplace(arguments.value, '[-]{2,}', '-', 'all');
		arguments.value = reReplace(arguments.value, '[~]{2,}', '~', 'all');
		
		// Check for path ending with a asterisk
		if (( !structKeyExists(arguments.options, 'allowWildcards') || !arguments.options.allowWildcards)
			&& len(arguments.value) > 1
			&& right(arguments.value, 1) == '*') {
			arguments.value = reReplace(arguments.value, '[*]+$', '');
		}
		
		// Check for path ending with a slash
		if (len(arguments.value) > 1 && right(arguments.value, 1) == '/') {
			arguments.value = reReplace(arguments.value, '[/]+$', '');
		}
		
		return arguments.value;
	}
	
	public string function createList( required string path, any keys = [''] ) {
		var pathList = '';
		var pathPart = '';
		var i = '';
		var j = '';
		
		// Make sure that the keys are an array
		if(!isArray(arguments.keys)) {
			arguments.keys = [ arguments.keys ];
		}
		
		// Default to a blank key if it doesn't have a key already
		if(!arrayLen(arguments.keys)) {
			arguments.keys = [''];
		}
		
		// Prepend a slash so it can be added to the end of the pathPart
		for( j = 1; j <= arrayLen(arguments.keys); j++ ) {
			if(arguments.keys[j] != '') {
				arguments.keys[j] = '/' & arguments.keys[j];
				
				// Add to the base path list
				pathList = listAppend(pathList, arguments.keys[j]);
			} else {
				// Handle the root path possibility
				pathList = listAppend(pathList, '/');
			}
		}
		
		// Make the list from each part of the provided path
		for( i = 1; i <= listLen(arguments.path, '/'); i++ ) {
			pathPart = listAppend(pathPart, listGetAt(arguments.path, i, '/'), '/');
			
			for( j = 1; j <= arrayLen(arguments.keys); j++ ) {
				pathList = listAppend(pathList, '/' & pathPart & arguments.keys[j]);
			}
		}
		
		return pathList;
	}
	
	public numeric function getLevel( required string path ) {
		var levels = 0;
		
		levels = listLen(arguments.path, '/');
		
		return levels;
	}
}
