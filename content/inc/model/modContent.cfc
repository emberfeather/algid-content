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
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modContent') />
		
		<!--- Prime to blank --->
		<cfset this.setContentHtml('') />
		
		<cfreturn this />
	</cffunction>
<cfscript>
	/**
	 * When setting the content the contentHtml should also be reset to the same value.
	 */
	/* required value */
	public void function setContent( string value ) {
		// Set both the content and the contentHtml to the value
		variables.instance['content'] = arguments.value;
		variables.instance['contentHtml'] = arguments.value;
	}
</cfscript>
</cfcomponent>
