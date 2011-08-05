<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Content ID --->
		<cfset add__attribute(
			attribute = 'contentID'
		) />
		
		<!--- Archived On --->
		<cfset add__attribute(
			attribute = 'archivedOn'
		) />
		
		<!--- Content --->
		<cfset add__attribute(
			attribute = 'content'
		) />
		
		<!--- CreatedOn --->
		<cfset add__attribute(
			attribute = 'createdOn'
		) />
		
		<!--- Do Caching --->
		<cfset add__attribute(
			attribute = 'doCaching',
			defaultValue = true,
			validation = {
				isBoolean = true
			}
		) />
		
		<!--- Domain ID --->
		<cfset add__attribute(
			attribute = 'domainID'
		) />
		
		<!--- Expires On --->
		<cfset add__attribute(
			attribute = 'expiresOn'
		) />
		
		<!--- Is Error? --->
		<cfset add__attribute(
			attribute = 'isError',
			defaultValue = false
		) />
		
		<!--- Modified On --->
		<cfset add__attribute(
			attribute = 'modifiedOn'
		) />
		
		<!--- Paths --->
		<cfset add__attribute(
			attribute = 'paths',
			defaultValue = []
		) />
		
		<!--- Title --->
		<cfset add__attribute(
			attribute = 'title'
		) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modContent') />
		
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
		var foundLen = len(arguments.found);
		
		if(foundLen > 1 && right(arguments.found, 2) == '/*') {
			arguments.found = (foundLen > 2 ? left(arguments.found, foundLen - 2) : '');
			
			foundLen = len(arguments.found);
		}
		
		if(len(arguments.requested) gt foundLen) {
			extra = right(arguments.requested, len(arguments.requested) - foundLen);
		}
		
		variables.instance['pathExtra'] = extra;
	}
</cfscript>
</cfcomponent>
