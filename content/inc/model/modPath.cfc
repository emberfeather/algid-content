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
				attribute = 'orderBy',
				defaultValue = 0
			) />
		
		<!--- Path --->
		<cfset addAttribute(
				attribute = 'path',
				defaultValue = '/'
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
		
		<cfset arguments.value = trim(arguments.value) />
		
		<!--- Convert standard characters --->
		<cfset arguments.value = replaceList(arguments.value, '\, ','/,_') />
		
		<!--- Check for invalid characters --->
		<cfif reFind('[^/a-zA-Z0-9-\._~-]', arguments.value)>
			<cfthrow type="validation" message="The path can only contain characters that contain uppercase and lowercase letters, decimal digits, hyphen, period, underscore, and tilde" />
		</cfif>
		
		<!--- Check for blank path --->
		<cfif arguments.value eq ''>
			<cfset arguments.value = '/' />
		</cfif>
		
		<!--- Check for path not starting with a slash --->
		<cfif left(arguments.value, 1) neq '/'>
			<cfset arguments.value = '/' & arguments.value />
		</cfif>
		
		<!--- Strip repeating symbols --->
		<cfset arguments.value = reReplace(arguments.value, '[/]{2,}', '/', 'all') />
		<cfset arguments.value = reReplace(arguments.value, '[_]{2,}', '_', 'all') />
		<cfset arguments.value = reReplace(arguments.value, '[-]{2,}', '-', 'all') />
		<cfset arguments.value = reReplace(arguments.value, '[~]{2,}', '~', 'all') />
		
		<!--- Check for path ending with a slash --->
		<cfif right(arguments.value, 1) eq '/'>
			<cfset arguments.value = reReplace(arguments.value, '[/]+$', '') />
		</cfif>
		
		<cfset variables.instance['path'] = arguments.value />
	</cffunction>
</cfcomponent>