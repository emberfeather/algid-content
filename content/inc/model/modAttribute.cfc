<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Attribute ID --->
		<cfset add__attribute(
				attribute = 'attributeID'
			) />
		
		<!--- Theme ID --->
		<cfset add__attribute(
				attribute = 'themeID'
			) />
		
		<!--- Attribute --->
		<cfset add__attribute(
				attribute = 'attribute'
			) />
		
		<!--- Key --->
		<cfset add__attribute(
				attribute = 'key'
			) />
		
		<!--- Has Custom --->
		<cfset add__attribute(
				attribute = 'hasCustom'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modAttribute') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>