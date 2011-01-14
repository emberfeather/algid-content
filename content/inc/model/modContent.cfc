<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Content ID --->
		<cfset addAttribute(
			attribute = 'contentID'
		) />
		
		<!--- Archived On --->
		<cfset addAttribute(
			attribute = 'archivedOn'
		) />
		
		<!--- Content --->
		<cfset addAttribute(
			attribute = 'content'
		) />
		
		<!--- CreatedOn --->
		<cfset addAttribute(
			attribute = 'createdOn'
		) />
		
		<!--- Do Caching --->
		<cfset addAttribute(
			attribute = 'doCaching',
			defaultValue = true,
			validation = {
				isBoolean = true
			}
		) />
		
		<!--- Domain ID --->
		<cfset addAttribute(
			attribute = 'domainID'
		) />
		
		<!--- Expires On --->
		<cfset addAttribute(
			attribute = 'expiresOn'
		) />
		
		<!--- Is Error? --->
		<cfset addAttribute(
			attribute = 'isError',
			defaultValue = false
		) />
		
		<!--- Modified On --->
		<cfset addAttribute(
			attribute = 'modifiedOn'
		) />
		
		<!--- Paths --->
		<cfset addAttribute(
			attribute = 'paths',
			defaultValue = []
		) />
		
		<!--- Title --->
		<cfset addAttribute(
			attribute = 'title'
		) />
		
		<!--- Type ID --->
		<cfset addAttribute(
			attribute = 'typeID'
		) />
		
		<!--- Set the bundle information for translation --->
		<cfset addBundle('plugins/content/i18n/inc/model', 'modContent') />
		
		<!--- Prime to blank --->
		<cfset this.setContentHtml('') />
		<cfset this.setPathExtra('', '') />
		
		<cfreturn this />
	</cffunction>
<cfscript>
	/**
	 * When setting the content the contentHtml should also be reset to the same value.
	 */
	public void function setContent( required string value ) {
		// Set both the content and the contentHtml to the value
		variables.instance['content'] = arguments.value;
		variables.instance['contentHtml'] = arguments.value;
	}
	
	/**
	 * When requesting content with a path that is matched by a wildcard
	 * this function assists in returning finding just the extra 
	 */
	public void function setPathExtra( required string requested, required string found ) {
		var extra = '';
		
		if(right(arguments.found, 2) == '/*') {
			arguments.found = left(arguments.found, len(arguments.found) - len('/*'));
		}
		
		if(len(arguments.requested) gt len(arguments.found)) {
			extra = right(arguments.requested, len(arguments.requested) - len(arguments.found));
		}
		
		variables.instance['pathExtra'] = extra;
	}
</cfscript>
</cfcomponent>
