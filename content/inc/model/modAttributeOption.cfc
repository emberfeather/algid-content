<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Attribute Option ID --->
		<cfset addAttribute(
				attribute = 'attributeOptionID'
			) />
		
		<!--- Attribute ID --->
		<cfset addAttribute(
				attribute = 'attributeID'
			) />
		
		<!--- Label --->
		<cfset addAttribute(
				attribute = 'label'
			) />
		
		<!--- Value --->
		<cfset addAttribute(
				attribute = 'value'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modAttributeOption') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>