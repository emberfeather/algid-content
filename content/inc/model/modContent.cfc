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
		
		<!--- Title --->
		<cfset addAttribute(
				attribute = 'title'
			) />
		
		<!--- Type ID --->
		<cfset addAttribute(
				attribute = 'typeID'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'objContent') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>