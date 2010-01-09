<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Theme ID --->
		<cfset addAttribute(
				attribute = 'themeID'
			) />
		
		<!--- Archived On --->
		<cfset addAttribute(
				attribute = 'archivedOn'
			) />
		
		<!--- Directory --->
		<cfset addAttribute(
				attribute = 'directory'
			) />
		
		<!--- Is Public? --->
		<cfset addAttribute(
				attribute = 'isPublic'
			) />
		
		<!--- Levels --->
		<cfset addAttribute(
				attribute = 'levels'
			) />
		
		<!--- Theme --->
		<cfset addAttribute(
				attribute = 'theme'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modTheme') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>