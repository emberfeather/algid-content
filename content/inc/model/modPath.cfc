<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Path ID --->
		<cfset addAttribute(
				attribute = 'pathID'
			) />
		
		<!--- Content ID --->
		<cfset addAttribute(
				attribute = 'contentID'
			) />
		
		<!--- Is Active? --->
		<cfset addAttribute(
				attribute = 'isActive'
			) />
		
		<!--- Group By --->
		<cfset addAttribute(
				attribute = 'groupBy'
			) />
		
		<!--- Navigation ID --->
		<cfset addAttribute(
				attribute = 'navigationID'
			) />
		
		<!--- Order By --->
		<cfset addAttribute(
				attribute = 'orderBy'
			) />
		
		<!--- Path --->
		<cfset addAttribute(
				attribute = 'path'
			) />
		
		<!--- Title --->
		<cfset addAttribute(
				attribute = 'title'
			) />
		
		<!--- Theme ID --->
		<cfset addAttribute(
				attribute = 'themeID'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/content/i18n/inc/model', 'modPath') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setPath" access="public" returntype="void" output="false">
		<cfargument name="value" type="string" required="true" />
		
		<!--- Convert forward and backslashes to periods --->
		<cfset arguments.value = replaceList(arguments.value, '/,\','.,.') />
		
		<cfset arguments.value = trim(arguments.value) />
		
		<!--- Check for blank path --->
		<cfif arguments.value eq ''>
			<cfthrow type="validation" message="The path cannot be blank" />
		</cfif>
		
		<!--- Check for path not starting with a dot --->
		<cfif left(arguments.value, 1) neq '.'>
			<cfthrow type="validation" message="The path needs to start with a period" />
		</cfif>
		
		<cfset variables.instance.path = arguments.value />
	</cffunction>
</cfcomponent>