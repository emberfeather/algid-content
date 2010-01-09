<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Domain ID --->
		<cfset addAttribute(
				attribute = 'domainID'
			) />
		
		<!--- Archived On --->
		<cfset addAttribute(
				attribute = 'archivedOn'
			) />
		
		<!--- Domain --->
		<cfset addAttribute(
				attribute = 'domain'
			) />
		
		<!--- CreatedOn --->
		<cfset addAttribute(
				attribute = 'createdOn'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modDomain') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>