<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Domain ID --->
		<cfset add__attribute(
				attribute = 'domainID'
			) />
		
		<!--- Archived On --->
		<cfset add__attribute(
				attribute = 'archivedOn'
			) />
		
		<!--- CreatedOn --->
		<cfset add__attribute(
				attribute = 'createdOn'
			) />
		
		<!--- Domain --->
		<cfset add__attribute(
				attribute = 'domain'
			) />
		
		<!--- Hosts --->
		<cfset add__attribute(
				attribute = 'hosts',
				defaultValue = []
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modDomain') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
