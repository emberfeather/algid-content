<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Attribute Option ID --->
		<cfset add__attribute(
				attribute = 'attributeOptionID'
			) />
		
		<!--- Attribute ID --->
		<cfset add__attribute(
				attribute = 'attributeID'
			) />
		
		<!--- Label --->
		<cfset add__attribute(
				attribute = 'label'
			) />
		
		<!--- Value --->
		<cfset add__attribute(
				attribute = 'value'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/content/i18n/inc/model', 'modAttributeOption') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>