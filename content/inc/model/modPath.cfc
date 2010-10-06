<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Path ID --->
		<cfset addAttribute(
				attribute = 'pathID'
			) />
		
		<!--- Content ID --->
		<cfset addAttribute(
				attribute = 'contentID'
			) />
		
		<!--- Is Active? --->
		<cfset addAttribute(
				attribute = 'isActive'
			) />
		
		<!--- Group By --->
		<cfset addAttribute(
				attribute = 'groupBy'
			) />
		
		<!--- Navigation ID --->
		<cfset addAttribute(
				attribute = 'navigationID'
			) />
		
		<!--- Order By --->
		<cfset addAttribute(
				attribute = 'orderBy',
				defaultValue = 0
			) />
		
		<!--- Path --->
		<cfset addAttribute(
				attribute = 'path',
				defaultValue = '/'
			) />
		
		<!--- Template --->
		<cfset addAttribute(
				attribute = 'template',
				defaultValue = 'index'
			) />
		
		<!--- Title --->
		<cfset addAttribute(
				attribute = 'title'
			) />
		
		<!--- Theme ID --->
		<cfset addAttribute(
				attribute = 'themeID'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset addBundle('plugins/content/i18n/inc/model', 'modPath') />
		
		<!---
			Set pattern for valid URL path characters.
			
			@see http://www.w3.org/Addressing/URL/url-spec.txt
		--->
		<cfset variables.validPathChars = '/a-zA-Z0-9\._~$@&%+\!\*"''\(\),-' />
		
		<cfreturn this />
	</cffunction>

<cfscript>
	public string function cleanPath( required string value ) {
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
		
		// Check for path ending with a slash
		if (len(arguments.value) gt 1 and right(arguments.value, 1) eq '/') {
			arguments.value = reReplace(arguments.value, '[/]+$', '');
		}
		
		return arguments.value;
	}
	
	public void function setPath( required string value ) {
		variables.instance['path'] = cleanPath(arguments.value);
	}
	
	public void function validatePath( required string value ) {
		var locate = '';
		var start = 0;
		
		arguments.value = trim(arguments.value);
		
		// Check for starting slash
		if (reFind('^[^/]', arguments.value)) {
			throw(type="validation", message="The path can must start with a forward slash");
		}
		
		// Check for invalid characters
		if (reFind('[^' & variables.validPathChars & ']', arguments.value)) {
			throw(type="validation", message="The path can only contain characters that contain uppercase and lowercase letters, decimal digits, hyphen, period, underscore, and tilde", detail='See the URL specification for path at http://www.w3.org/Addressing/URL/url-spec.txt');
		}
		
		// Check for invalid hex escapes
		if (find('%', arguments.value)) {
			while( find('%', arguments.value, start) ) {
				locate = reFind('%.{2}', arguments.value, start, true);
				
				if(!locate.pos[1] || not reFind('%[a-zA-Z0-9]{2}', mid(arguments.value, locate.pos[1], locate.len[1])) ) {
					throw(type="validation", message="The path can only contain the % when followed by two hexadecimal characters", detail='See the URL specification for escape at http://www.w3.org/Addressing/URL/url-spec.txt');
				}
				
				start = locate.pos[1] + locate.len[1];
			}
		}
	}
</cfscript>
</cfcomponent>