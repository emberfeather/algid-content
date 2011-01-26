<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Meta ID --->
		<cfset add__attribute(
				attribute = 'metaID'
			) />
		
		<!--- Content ID --->
		<cfset add__attribute(
				attribute = 'contentID'
			) />
		
		<!--- Name --->
		<cfset add__attribute(
				attribute = 'name'
			) />
		
		<!--- Value --->
		<cfset add__attribute(
				attribute = 'value'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modMeta') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>