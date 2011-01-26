<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Host ID --->
		<cfset add__attribute(
				attribute = 'hostID'
			) />
		
		<!--- Domain ID --->
		<cfset add__attribute(
				attribute = 'domainID'
			) />
		
		<!--- Hostname --->
		<cfset add__attribute(
				attribute = 'hostname'
			) />
		
		<!--- Is Primary --->
		<cfset add__attribute(
				attribute = 'isPrimary',
				defaultValue = false
			) />
		
		<!--- hasSSL --->
		<cfset add__attribute(
				attribute = 'hasSSL',
				defaultValue = false
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modDomain') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
