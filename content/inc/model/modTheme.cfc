<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Theme ID --->
		<cfset add__attribute(
				attribute = 'themeID'
			) />
		
		<!--- Archived On --->
		<cfset add__attribute(
				attribute = 'archivedOn'
			) />
		
		<!--- Directory --->
		<cfset add__attribute(
				attribute = 'directory'
			) />
		
		<!--- Is Public? --->
		<cfset add__attribute(
				attribute = 'isPublic',
				defaultValue = false
			) />
		
		<!--- Levels --->
		<cfset add__attribute(
				attribute = 'levels',
				defaultValue = 0
			) />
		
		<!--- Navigation --->
		<cfset add__attribute(
				attribute = 'navigation',
				defaultValue = []
			) />
		
		<!--- Theme --->
		<cfset add__attribute(
				attribute = 'theme'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modTheme') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPlugin" access="public" returntype="string" output="false">
		<cfreturn listFirst(this.getDirectory(), '/') />
	</cffunction>
	
	<cffunction name="getThemeKey" access="public" returntype="string" output="false">
		<cfreturn listLast(this.getDirectory(), '/') />
	</cffunction>
</cfcomponent>
