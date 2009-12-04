<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Attribute ID --->
		<cfset addAttribute(
				attribute = 'attributeID',
				defaultValue = 0
			) />
		
		<!--- Theme ID --->
		<cfset addAttribute(
				attribute = 'themeID',
				defaultValue = 0
			) />
		
		<!--- Attribute --->
		<cfset addAttribute(
				attribute = 'attribute'
			) />
		
		<!--- Key --->
		<cfset addAttribute(
				attribute = 'key'
			) />
		
		<!--- Has Custom --->
		<cfset addAttribute(
				attribute = 'hasCustom'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modAttribute') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>