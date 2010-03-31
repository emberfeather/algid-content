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
		
		<!--- Title --->
		<cfset addAttribute(
				attribute = 'title'
			) />
		
		<!--- Theme ID --->
		<cfset addAttribute(
				attribute = 'themeID'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modPath') />
		
		<cfreturn this />
	</cffunction>

<cfscript>
	/* required value */
	public string function cleanPath( string value ) {
		arguments.value = trim(arguments.value);
		
		// Convert standard characters
		arguments.value = replaceList(arguments.value, '\, ','/,_');
		
		// Check for invalid characters
		if (reFind('[^/a-zA-Z0-9-\._~-]', arguments.value)) {
			throw(type="validation", message="The path can only contain characters that contain uppercase and lowercase letters, decimal digits, hyphen, period, underscore, and tilde");
		}
		
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
	
	/* required value */
	public void function setPath( string value ) {
		variables.instance['path'] = cleanPath(arguments.value);
	}
</cfscript>
</cfcomponent>