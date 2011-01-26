<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Type ID --->
		<cfset add__attribute(
				attribute = 'typeID'
			) />
		
		<!--- Type --->
		<cfset add__attribute(
				attribute = 'type'
			) />
		
		<!--- Archived On --->
		<cfset add__attribute(
				attribute = 'archivedOn'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modType') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>