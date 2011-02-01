<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Resource ID --->
		<cfset add__attribute(
				attribute = 'resourceID'
			) />
		
		<!--- Archived On --->
		<cfset add__attribute(
				attribute = 'archivedOn'
			) />
		
		<!--- Created On --->
		<cfset add__attribute(
				attribute = 'createdOn'
			) />
		
		<!--- Deprecated On --->
		<cfset add__attribute(
				attribute = 'deprecatedOn'
			) />
		
		<!--- File --->
		<cfset add__attribute(
				attribute = 'file'
			) />
		
		<!--- Is Public? --->
		<cfset add__attribute(
				attribute = 'isPublic'
			) />
		
		<!--- Resource --->
		<cfset add__attribute(
				attribute = 'resource'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modTheme') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>