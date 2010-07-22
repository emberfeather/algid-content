<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Host ID --->
		<cfset addAttribute(
				attribute = 'hostID'
			) />
		
		<!--- Domain ID --->
		<cfset addAttribute(
				attribute = 'domainID'
			) />
		
		<!--- Hostname --->
		<cfset addAttribute(
				attribute = 'hostname'
			) />
		
		<!--- Is Primary --->
		<cfset addAttribute(
				attribute = 'isPrimary',
				defaultValue = false
			) />
		
		<!--- hasSSL --->
		<cfset addAttribute(
				attribute = 'hasSSL',
				defaultValue = false
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modDomain') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
