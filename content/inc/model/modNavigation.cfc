<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Navigation ID --->
		<cfset addAttribute(
				attribute = 'navigationID'
			) />
		
		<!--- Allow Groups? --->
		<cfset addAttribute(
				attribute = 'allowGroups',
				defaultValue = false
			) />
		
		<!--- Level --->
		<cfset addAttribute(
				attribute = 'level',
				defaultValue = 0
			) />
		
		<!--- Navigation --->
		<cfset addAttribute(
				attribute = 'navigation'
			) />
		
		<!--- Theme ID --->
		<cfset addAttribute(
				attribute = 'themeID'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset addBundle('plugins/content/i18n/inc/model', 'modNavigation') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
