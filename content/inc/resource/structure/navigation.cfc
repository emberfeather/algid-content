<cfcomponent extends="algid.inc.resource.base.navigation" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		<cfargument name="i18n" type="component" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.i18n = arguments.i18n />
		<cfset variables.datasource = arguments.datasource />
		
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
		<cfquery name="navigation" datasource="#variables.datasource.name#">
			SELECT c."contentID", p."path", c."title", p."title" AS "navTitle", n."navigation", a."attribute", ao."value" AS "attributeOptionValue", pa."value" AS "attributeValue", p."orderBy"
			FROM "#variables.datasource.prefix#content"."content" c
			JOIN "#variables.datasource.prefix#content"."domain" d
				ON c."domainID" = d."domainID"
					AND d."domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain#" />
			JOIN "#variables.datasource.prefix#content"."path" p
				ON c."contentID" = p."contentID"
			JOIN "#variables.datasource.prefix#content"."navigation" n
				ON p."navigationID" = n."navigationID"
			LEFT JOIN "#variables.datasource.prefix#content"."bPath2Attribute" pa
				ON p."pathID" = pa."pathID"
			LEFT JOIN "#variables.datasource.prefix#content"."attribute" a
				ON pa."attributeID" = a."attributeID"
			LEFT JOIN "#variables.datasource.prefix#content"."attributeOption" ao
				ON pa."attributeOptionID" = ao."attributeOptionID"
			WHERE 
				n."level" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level#" />
				AND p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentPath#%" />
				AND n."navigation" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navPosition#" />
			
			<!--- TODO add in locale Support --->
				<!--- and "locale" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" /> --->
			
			<!--- Check if we want to return blank nav titles --->
			<cfif structKeyExists(arguments.options, 'hideBlankNavTitles') and arguments.options.hideBlankNavTitles eq true>
				AND p."title" <> <cfqueryparam cfsqltype="cf_sql_varchar" value="" />
			</cfif>
			
			<!--- TODO Permission checking --->
			
			ORDER BY p."orderBy" ASC, p."title" ASC
		</cfquery>
		
		<cfreturn navigation />
	</cffunction>
	
	<cffunction name="getNavigation" access="public" returntype="query" output="false">
		<cfreturn variables.navigation />
	</cffunction>
	
	<cffunction name="locatePage" access="public" returntype="component" output="false">
		<cfargument name="domain" type="string" required="true" />
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="locale" type="string" required="true" />
		<cfargument name="authUser" type="component" required="false" />
		
		<cfset var currentPage = createObject('component', 'algid.inc.resource.structure.currentPage').init() />
		<cfset var paths = '' />
		<cfset var locate = '' />
		<cfset var currentPath = '' />
		
		<!--- Check the base path --->
		<cfset currentPath = arguments.theURL.search('_base') />
		<cfset currentPath = currentPath eq '' ? variables.defaultRoot : currentPath />
		
		<!--- Query for the exact pages that match the paths --->
		<cfquery name="locate" datasource="#variables.datasource.name#">
			SELECT p."path", c."title", p."title" AS "navTitle"
			FROM "#variables.datasource.prefix#content"."content" c
			JOIN "#variables.datasource.prefix#content"."domain" d
				ON c."domainID" = d."domainID"
					AND d."domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain#" />
			JOIN "#variables.datasource.prefix#content"."path" p
				ON c."contentID" = p."contentID"
			WHERE 1 = 1
				AND (
					"path" IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#createPathList(currentPath)#" list="true" />)
					OR "path" IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#createPathList(currentPath, '*')#" list="true" />)
				)
				
				<!--- TODO add in authUser type permission checking --->
			ORDER BY path ASC
		</cfquery>
		
		<!--- Prime the URL --->
		<cfset arguments.theURL.cleanCurrent() />
		
		<cfloop query="locate">
			<!--- Create the url --->
			<cfset arguments.theURL.setCurrent('_base', locate.path) />
			
			<!--- Add to the current page --->
			<cfset currentPage.addLevel(locate.title, locate.navTitle, arguments.theURL.getCurrent(), locate.path) />
		</cfloop>
		
		<cfreturn currentPage />
	</cffunction>
</cfcomponent>
