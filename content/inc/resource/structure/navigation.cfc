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
	
	<cffunction name="cleanPath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfset var pathLen = len(arguments.path) />
		
		<cfif pathLen gt 1 and right(arguments.path, 2) eq '/*'>
			<cfset arguments.path = (pathLen gt 2 ? left(arguments.path, pathLen - 2) : '') />
		</cfif>
		
		<cfreturn arguments.path />
	</cffunction>
	
	<cffunction name="createUniqueNavigationKey" access="private" returntype="string" output="false">
		<cfargument name="domain" type="string" required="true" />
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="level" type="numeric" required="true" />
		<cfargument name="navPosition" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var i = '' />
		<cfset var position = '' />
		<cfset var uniqueContentID = '' />
		
		<cfif isArray(arguments.navPosition)>
			<cfloop array="#arguments.navPosition#" index="i">
				<cfset position &= i & '/' />
			</cfloop>
			
			<cfset position = left(position, len(position) - 1) />
		<cfelse>
			<cfset position = arguments.navPosition />
		</cfif>
		
		<cfset uniqueContentID = arguments.domain & arguments.theURL.search('_base') & '--' & arguments.locale & '--' & arguments.level & '--' & position />
		
		<cfif structKeyExists(arguments.options, 'depth')>
			<cfset uniqueContentID &= '--depth' & arguments.options.depth />
		</cfif>
		
		<cfreturn uniqueContentID />
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
			SELECT c."contentID", p."path", c."title", bpn."title" AS "navTitle", n."navigation", a."attribute", ao."value" AS "attributeOptionValue", pa."value" AS "attributeValue", bpn."orderBy", '' AS ids, '' AS vars
			FROM "#variables.datasource.prefix#content"."content" c
			JOIN "#variables.datasource.prefix#content"."host" h
				ON c."domainID" = h."domainID"
					AND h."hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain#" />
			JOIN "#variables.datasource.prefix#content"."path" p
				ON c."contentID" = p."contentID"
			JOIN "#variables.datasource.prefix#content"."bPath2Navigation" bpn
				ON bpn."pathID" = p."pathID"
			JOIN "#variables.datasource.prefix#content"."navigation" n
				ON bpn."navigationID" = n."navigationID"
			LEFT JOIN "#variables.datasource.prefix#content"."bPath2Attribute" pa
				ON p."pathID" = pa."pathID"
			LEFT JOIN "#variables.datasource.prefix#content"."attribute" a
				ON pa."attributeID" = a."attributeID"
			LEFT JOIN "#variables.datasource.prefix#content"."attributeOption" ao
				ON pa."attributeOptionID" = ao."attributeOptionID"
			WHERE 
				n."level" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level#" />
				AND c."archivedOn" IS NULL
				AND p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentPath#%" />
				AND n."navigation" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navPosition#" />
			
			<!--- TODO add in locale Support --->
				<!--- and "locale" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" /> --->
			
			<!--- Check if we want to return blank nav titles --->
			<cfif structKeyExists(arguments.options, 'hideBlankNavTitles') and arguments.options.hideBlankNavTitles eq true>
				AND bpn."title" <> <cfqueryparam cfsqltype="cf_sql_varchar" value="" />
			</cfif>
			
			<!--- TODO Permission checking --->
			
			ORDER BY bpn."orderBy" ASC, bpn."title" ASC
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
			SELECT DISTINCT p."path", c."title", bpn."title" AS "navTitle"
			FROM "#variables.datasource.prefix#content"."content" c
			JOIN "#variables.datasource.prefix#content"."host" h
				ON c."domainID" = h."domainID"
					AND h."hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain#" />
			JOIN "#variables.datasource.prefix#content"."path" p
				ON c."contentID" = p."contentID"
			LEFT JOIN "#variables.datasource.prefix#content"."bPath2Navigation" bpn
				ON p."pathID" = bpn."pathID"
			WHERE 1 = 1
				AND (
					p."path" IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#createPathList(currentPath)#" list="true" />)
					OR p."path" IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#createPathList(currentPath, '*')#" list="true" />)
				)
			ORDER BY p.path ASC
		</cfquery>
		
		<!--- Prime the URL --->
		<cfset arguments.theURL.cleanCurrent() />
		
		<cfloop query="locate">
			<!--- Create the url --->
			<cfset arguments.theURL.setCurrent('_base', cleanPath(locate.path)) />
			
			<!--- Add to the current page --->
			<cfset currentPage.addLevel(locate.title, locate.navTitle, arguments.theURL.getCurrent(), locate.path) />
		</cfloop>
		
		<cfreturn currentPage />
	</cffunction>
	
	<cffunction name="toHTML" access="public" returntype="string" output="false">
		<cfargument name="domain" type="string" required="true" />
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="level" type="numeric" required="true" />
		<cfargument name="navPosition" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		<cfargument name="locale" type="string" default="en_US" />
		<cfargument name="authUser" type="component" required="false" />
		<cfargument name="cache" type="component" required="false" />
		
		<cfset var html = '' />
		<cfset var uniqueKey = '' />
		
		<!--- Check for a logged-in user -- NO caching --->
		<cfif structKeyExists(arguments, 'authUser') and arguments.authUser.isLoggedIn()>
			<cfreturn super.toHTML(argumentCollection = arguments) />
		</cfif>
		
		<!--- Check is we have a cache to use --->
		<cfif structKeyExists(arguments, 'cache')>
			<!--- Determine a unique identification for caching purposes --->
			<cfset uniqueKey = createUniqueNavigationKey(argumentCollection = arguments) />
			
			<cfif not arguments.cache.has(uniqueKey)>
				<cfset arguments.cache.put(uniqueKey, super.toHtml(argumentCollection = arguments)) />
			</cfif>
			
			<cfreturn arguments.cache.get(uniqueKey) />
		</cfif>
		
		<cfreturn super.toHTML(argumentCollection = arguments) />
	</cffunction>
</cfcomponent>
