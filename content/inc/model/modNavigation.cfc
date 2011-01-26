<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Navigation ID --->
		<cfset add__attribute(
				attribute = 'navigationID'
			) />
		
		<!--- Allow Groups? --->
		<cfset add__attribute(
				attribute = 'allowGroups',
				defaultValue = false
			) />
		
		<!--- Level --->
		<cfset add__attribute(
				attribute = 'level',
				defaultValue = 0
			) />
		
		<!--- Navigation --->
		<cfset add__attribute(
				attribute = 'navigation'
			) />
		
		<!--- Theme ID --->
		<cfset add__attribute(
				attribute = 'themeID'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modNavigation') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
