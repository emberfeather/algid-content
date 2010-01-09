<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Content ID --->
		<cfset addAttribute(
				attribute = 'contentID'
			) />
		
		<!--- Draft --->
		<cfset addAttribute(
				attribute = 'draft'
			) />
		
		<!--- CreatedOn --->
		<cfset addAttribute(
				attribute = 'createdOn'
			) />
		
		<!--- PublishOn --->
		<cfset addAttribute(
				attribute = 'publishOn'
			) />
		
		<!--- UpdatedOn --->
		<cfset addAttribute(
				attribute = 'updatedOn'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modDraft') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>