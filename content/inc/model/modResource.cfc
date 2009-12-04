<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Resource ID --->
		<cfset addAttribute(
				attribute = 'resourceID',
				defaultValue = 0
			) />
		
		<!--- Archived On --->
		<cfset addAttribute(
				attribute = 'archivedOn'
			) />
		
		<!--- Created On --->
		<cfset addAttribute(
				attribute = 'createdOn'
			) />
		
		<!--- Deprecated On --->
		<cfset addAttribute(
				attribute = 'deprecatedOn'
			) />
		
		<!--- File --->
		<cfset addAttribute(
				attribute = 'file'
			) />
		
		<!--- Is Public? --->
		<cfset addAttribute(
				attribute = 'isPublic'
			) />
		
		<!--- Resource --->
		<cfset addAttribute(
				attribute = 'resource'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modTheme') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>