<cfcomponent extends="algid.inc.resource.base.navigation" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		
		<cfset super.init() />
		
		<!--- Store the i18n information --->
		<cfset variables.i18n = arguments.i18n />
		
		<!--- Use a query for the navigation storage --->
		<cfset variables.navigation = '' />
		
		<!--- The default root is used when there is no base path given --->
		<cfset variables.defaultRoot = '/' />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getNav" access="public" returntype="query" output="false">
		<cfargument name="domain" type="string" required="true" />
		<cfargument name="level" type="numeric" required="true" />
		<cfargument name="navPosition" type="string" required="true" />
		<cfargument name="parentPath" type="string" default="." />
		<cfargument name="options" type="struct" default="#{}#" />
		<cfargument name="locale" type="string" default="en_US" />
		<cfargument name="authUser" type="component" required="false" />
		
		<cfset var navigation = '' />
		<cfset var permission = '' />
		<cfset var permissions = '' />
		
		<!--- Retrieve user permissions --->
		<cfif structKeyExists(arguments, 'authUser')>
			<cfset permissions = arguments.authUser.getPermissions('*') />
		</cfif>
		
		<!--- Query the navigation query for the page information --->
		<cfquery name="navigation" dbtype="query">
			SELECT "contentID", "level", "path", "title", "navTitle", "navPosition", "description", "ids", "vars", "attribute", "attributeValue", "allow", "deny", "secureOrder", "defaults", "orderBy"
			FROM "#variables.datasource.prefix#content"."content"
			WHERE "level" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level#" />
				and "path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentPath#%" />
				and "locale" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" />
				and "navPosition" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navPosition#" />
				
				<!--- Check if we want to return blank nav titles --->
				<cfif structKeyExists(arguments.options, 'hideBlankNavTitles') and arguments.options.hideBlankNavTitles eq true>
					and "navTitle" <> <cfqueryparam cfsqltype="cf_sql_varchar" value="" />
				</cfif>
				
				<!--- TODO Permission checking --->
				
				ORDER BY "orderBy" ASC, "navTitle" ASC
		</cfquery>
		
		<cfreturn navigation />
	</cffunction>
	
	<cffunction name="getNavigation" access="public" returntype="query" output="false">
		<cfreturn variables.navigation />
	</cffunction>
	
	<cffunction name="locatePage" access="public" returntype="component" output="false">
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="locale" type="string" required="true" />
		<cfargument name="authUser" type="component" required="false" />
		
		<cfset var currentPage = createObject('component', 'algid.inc.resource.structure.currentPage').init() />
		<cfset var paths = '' />
		<cfset var navigation = '' />
		<cfset var currentPath = '' />
		
		<!--- Check the base path --->
		<cfset currentPath = arguments.theURL.search('_base') />
		
		<!--- Explode the current path --->
		<cfset paths = explodePath(currentPath eq '' ? variables.defaultRoot : currentPath) />
		
		<!--- Query for the exact pages that match the paths --->
		<cfquery name="navigation" dbtype="query">
			SELECT contentID, [level], path, title, navTitle, navPosition, description, ids, vars, attribute, attributeValue, allow, deny, defaults, contentPath, orderBy
			FROM variables.navigation
			WHERE path IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arrayToList(paths)#" list="true" />)
				and locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" />
				
				<!--- TODO add in authUser type permission checking --->
				
				ORDER BY path ASC
		</cfquery>
		
		<!--- Prime the URL --->
		<cfset arguments.theURL.cleanCurrent() />
		
		<cfloop query="navigation">
			<!--- Create the url --->
			<cfset arguments.theURL.setCurrent('_base', navigation.path) />
			
			<!--- Add to the current page --->
			<cfset currentPage.addLevel(navigation.title, navigation.navTitle, arguments.theURL.getCurrent(), navigation.path, navigation.contentPath) />
		</cfloop>
		
		<cfreturn currentPage />
	</cffunction>
</cfcomponent>
