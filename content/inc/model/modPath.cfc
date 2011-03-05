<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modPath') />
		
		<!--- Path ID --->
		<cfset add__attribute(
			attribute = 'pathID'
		) />
		
		<!--- Content ID --->
		<cfset add__attribute(
			attribute = 'contentID'
		) />
		
		<!--- Is Active? --->
		<cfset add__attribute(
			attribute = 'isActive'
		) />
		
		<!--- Group By --->
		<cfset add__attribute(
			attribute = 'groupBy'
		) />
		
		<!--- Navigation ID --->
		<cfset add__attribute(
			attribute = 'navigationID'
		) />
		
		<!--- Order By --->
		<cfset add__attribute(
			attribute = 'orderBy',
			defaultValue = 0
		) />
		
		<!--- Path --->
		<cfset add__attribute(
			attribute = 'path',
			defaultValue = '/',
			validation = {
				path = true
			}
		) />
		
		<!--- Template --->
		<cfset add__attribute(
			attribute = 'template',
			defaultValue = 'index'
		) />
		
		<!--- Title --->
		<cfset add__attribute(
			attribute = 'title'
		) />
		
		<!--- Theme ID --->
		<cfset add__attribute(
			attribute = 'themeID'
		) />
		
		<cfreturn this />
	</cffunction>
<cfscript>
	public string function cleanPath( required string value ) {
		arguments.value = trim(arguments.value);
		
		// Convert standard characters
		arguments.value = replaceList(arguments.value, '\, ','/,_');
		
		/**
		 * Remove invalid characters
		 * 
		 * @see http://www.w3.org/Addressing/URL/url-spec.txt
		 */
		arguments.value = reReplace(arguments.value, '[^/a-zA-Z0-9\._~$@&%+\!\*"''\(\),-]', '', 'all');
		
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
</cfscript>
</cfcomponent>