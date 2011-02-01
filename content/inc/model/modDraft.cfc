<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Content ID --->
		<cfset add__attribute(
				attribute = 'contentID'
			) />
		
		<!--- Draft --->
		<cfset add__attribute(
				attribute = 'draft'
			) />
		
		<!--- CreatedOn --->
		<cfset add__attribute(
				attribute = 'createdOn'
			) />
		
		<!--- PublishOn --->
		<cfset add__attribute(
				attribute = 'publishOn'
			) />
		
		<!--- UpdatedOn --->
		<cfset add__attribute(
				attribute = 'updatedOn'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modDraft') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>