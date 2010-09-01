<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getNavigation" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="navigationID" type="string" required="true" />
		
		<cfset var navigation = '' />
		<cfset var i = '' />
		<cfset var objectSerial = '' />
		<cfset var path = '' />
		<cfset var results = '' />
		<cfset var type = '' />
		
		<cfset navigation = getModel('content', 'navigation') />
		
		<cfif arguments.navigationID neq ''>
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "navigationID", "themeID", "navigation", "level", "allowGroups"
				FROM "#variables.datasource.prefix#content"."navigation"
				WHERE "navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigationID#" null="#arguments.navigationID eq ''#" />::uuid
				
				<!--- TODO Check for user connection --->
			</cfquery>
			
			<cfif results.recordCount>
				<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
				
				<cfset objectSerial.deserialize(results, navigation) />
			</cfif>
		</cfif>
		
		<cfreturn navigation />
	</cffunction>
	
	<cffunction name="getNavigations" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				alongPath = '',
				domain = '',
				orderBy = 'navigation',
				orderSort = 'asc',
				path = ''
			} />
		<cfset var hasExtraJoins = '' />
		<cfset var i = '' />
		<cfset var pathPart = '' />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "navigationID", "themeID", "navigation", "level", "allowGroups"
			FROM "#variables.datasource.prefix#content"."navigation"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND "navigation" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'themeID') and arguments.filter.themeID neq ''>
				AND "themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.themeID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'allowGroups')>
				AND "allowGroups" IS <cfif arguments.filter.allowGroups>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"navigation" #arguments.filter.orderSort#
				</cfdefaultcase>
			</cfswitch>
			
			<cfif structKeyExists(arguments.filter, 'limit')>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.limit#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'offset')>
				OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.offset#" />
			</cfif>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="setNavigation" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="navigation" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var isArchived = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'navigation') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.navigation) />
		
		<cfif arguments.navigation.getNavigationID() neq ''>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.currUser, arguments.navigation) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."navigation"
					SET
						"allowGroups" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigation.getAllowGroups()#" />::boolean
					WHERE
						"navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigation.getNavigationID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.navigation) />
		<cfelse>
			<!--- Before Create Event --->
			<cfset observer.beforeCreate(variables.transport, arguments.currUser, arguments.navigation) />
			
			<!--- Create the new ID --->
			<cfset arguments.navigation.setNavigationID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."navigation" (
						"navigationID",
						"themeID",
						"navigation",
						"level",
						"allowGroups"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigation.getNavigationID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigation.getThemeID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigation.getNavigation()#" />,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.navigation.getLevel()#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.navigation.getAllowGroups()#" />::boolean
					)
				</cfquery>
			</cftransaction>
			
			<!--- After Create Event --->
			<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.navigation) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.navigation) />
	</cffunction>
</cfcomponent>
