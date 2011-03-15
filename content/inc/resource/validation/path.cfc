component extends="cf-compendium.inc.resource.base.validator" {
	public void function path( required string label, required string value ) {
		local.start = 0;
		
		arguments.value = trim(arguments.value);
		
		// Check for starting slash
		if (reFind('^[^/]', arguments.value)) {
			local.message = variables.label.get('path_start_slash');
			
			throw(type="validation", message="#variables.format.format( local.message, arguments.label )#");
		}
		
		/**
		 * Check for invalid characters
		 * 
		 * @see http://www.w3.org/Addressing/URL/url-spec.txt
		 */
		if (reFind('[^/a-zA-Z0-9\._~$@&%+\!\*"''\(\),-]', arguments.value)) {
			local.message = variables.label.get('path_invalid_char');
			
			throw(type="validation", message="#variables.format.format( local.message, arguments.label )#", detail='See the URL specification for path at http://www.w3.org/Addressing/URL/url-spec.txt');
		}
		
		// Check for invalid hex escapes
		if (find('%', arguments.value)) {
			while( find('%', arguments.value, local.start) ) {
				local.locate = reFind('%.{2}', arguments.value, local.start, true);
				
				if(!local.locate.pos[1] || not reFind('%[a-zA-Z0-9]{2}', mid(arguments.value, local.locate.pos[1], local.locate.len[1])) ) {
					local.message = variables.label.get('path_invalid_hex_escape');
					
					throw(type="validation", message="#variables.format.format( local.message, arguments.label )#", detail='See the URL specification for escape at http://www.w3.org/Addressing/URL/url-spec.txt');
				}
				
				local.start = local.locate.pos[1] + local.locate.len[1];
			}
		}
	}
}
