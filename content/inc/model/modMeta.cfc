<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Meta ID --->
		<cfset addAttribute(
				attribute = 'metaID'
			) />
		
		<!--- Content ID --->
		<cfset addAttribute(
				attribute = 'contentID'
			) />
		
		<!--- Name --->
		<cfset addAttribute(
				attribute = 'name'
			) />
		
		<!--- Value --->
		<cfset addAttribute(
				attribute = 'value'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset addBundle('plugins/content/i18n/inc/model', 'modMeta') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>