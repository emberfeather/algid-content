<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="deleteNavigation" access="public" returntype="void" output="false">
		<cfargument name="navigation" type="component" required="true" />
		
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'navigation') />
		
		<!--- Before Delete Event --->
		<cfset observer.beforeDelete(variables.transport, arguments.navigation) />
		
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#">
				DELETE
				FROM "#variables.datasource.prefix#content"."navigation"
				WHERE "navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigation.getNavigationID()#" />::uuid
			</cfquery>
		</cftransaction>
		
		<!--- After Delete Event --->
		<cfset observer.afterDelete(variables.transport, arguments.navigation) />
	</cffunction>
	
	<cffunction name="getNavigation" access="public" returntype="component" output="false">
		<cfargument name="navigationID" type="string" required="true" />
		
		<cfset var navigation = '' />
		<cfset var i = '' />
		<cfset var modelSerial = '' />
		<cfset var path = '' />
		<cfset var results = '' />
		<cfset var type = '' />
		
		<cfset navigation = getModel('content', 'navigation') />
		
		<cfif arguments.navigationID neq ''>
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "navigationID", "themeID", "navigation", "level", "allowGroups"
				FROM "#variables.datasource.prefix#content"."navigation"
				WHERE "navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navigationID#" null="#arguments.navigationID eq ''#" />::uuid
			</cfquery>
			
			<cfif results.recordCount>
				<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
				
				<cfset modelSerial.deserialize(results, navigation) />
			</cfif>
		</cfif>
		
		<cfreturn navigation />
	</cffunction>
	
	<cffunction name="getNavigations" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
			orderBy = 'navigation',
			orderSort = 'asc'
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
			
			<cfif structKeyExists(arguments.filter, 'level') and isNumeric(arguments.filter.level) and arguments.filter.level gt 0>
				AND "level" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.level#" />
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
		<cfargument name="navigation" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var isArchived = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'navigation') />
		
		<cfset validate__model(arguments.navigation) />
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.navigation) />
		
		<cfif arguments.navigation.getNavigationID() neq ''>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.navigation) />
			
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
			<cfset observer.afterUpdate(variables.transport, arguments.navigation) />
		<cfelse>
			<!--- Before Create Event --->
			<cfset observer.beforeCreate(variables.transport, arguments.navigation) />
			
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
			<cfset observer.afterCreate(variables.transport, arguments.navigation) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.navigation) />
	</cffunction>
	
	<cffunction name="setPositions" access="public" returntype="void" output="false">
		<cfargument name="path" type="component" required="true" />
		<cfargument name="domain" type="component" required="true" />
		<cfargument name="positions" type="array" required="true" />
		
		<cfset var cleaned = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var isArchived = '' />
		<cfset var observer = '' />
		<cfset var position = '' />
		<cfset var results = '' />
		<cfset var pathClean = '' />
		<cfset var verify = '' />
		<cfset var saved = {} />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'navigation') />
		
		<!--- Before Position Event --->
		<cfset observer.beforePosition(variables.transport, arguments.path, arguments.positions) />
		
		<cfset pathClean = variables.transport.theApplication.managers.singleton.getPathForContent() />
		
		<cfset cleaned = pathClean.clean(arguments.path.getPath(), ['*']) />
		
		<cfif cleaned NEQ '/'>
			<cfset cleaned &= '/' />
		</cfif>
		
		<!--- Retrieve current navigation --->
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "pathID", "navigationID"
			FROM "#variables.datasource.prefix#content"."bPath2Navigation"
			WHERE
				"pathID" IN (
					<!--- Make sure all paths are directly off the base path, including wildcard paths --->
					SELECT p."pathID"
					FROM "#variables.datasource.prefix#content"."path" p
					JOIN "#variables.datasource.prefix#content"."content" c
					ON p."contentID" = c."contentID"
						AND c."domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid
					WHERE LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%" />
						AND (
							LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%" />
							OR (
								LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/*" />
								AND LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%/*" />
							)
						)
				)
		</cfquery>
		
		<cftransaction>
			<cfloop array="#arguments.positions#" index="position">
				<!--- Skip the hidden navigation --->
				<cfif position.navigationID eq ''>
					<cfcontinue />
				</cfif>
				
				<!--- Remove any paths that are no longer in the navigation position --->
				<cfquery datasource="#variables.datasource.name#">
					DELETE
					FROM "#variables.datasource.prefix#content"."bPath2Navigation"
					WHERE
						"navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position.navigationID#" />::uuid
						<cfif arrayLen(position.paths)>
							AND "pathID" NOT IN (
								<cfloop from="1" to="#arrayLen(position.paths)#" index="i">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].pathID#" />::uuid<cfif i lt arrayLen(position.paths)>,</cfif>
								</cfloop>
							)
						</cfif>
						AND "pathID" IN (
							<!--- Make sure all paths are directly off the base path, including wildcard paths --->
							SELECT p."pathID"
							FROM "#variables.datasource.prefix#content"."path" p
							JOIN "#variables.datasource.prefix#content"."content" c
							ON p."contentID" = c."contentID"
								AND c."domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid
							WHERE LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%" />
								AND (
									LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%" />
									OR (
										LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/*" />
										AND LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%/*" />
									)
								)
						)
				</cfquery>
				
				<!--- Track which combinations have already been updated --->
				<cfset saved[position.navigationID] = {} />
				
				<cfloop from="1" to="#arrayLen(position.paths)#" index="i">
					<!--- Make sure we have not already tried to update/insert this position --->
					<cfif not structKeyExists(saved[position.navigationID], position.paths[i].pathID.toString())>
						<cfset saved[position.navigationID][position.paths[i].pathID] = 1 />
						
						<!--- Check if the path and navigation combo exist --->
						<cfquery name="verify" dbtype="query">
							SELECT pathID
							FROM results
							WHERE navigationID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position.navigationID#" />
								AND pathID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].pathID#" />
						</cfquery>
						
						<cfif verify.recordCount>
							<cfquery datasource="#variables.datasource.name#">
								UPDATE "#variables.datasource.prefix#content"."bPath2Navigation"
								SET
									"title" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].title#" />,
									"groupBy" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].groupBy#" />,
									"orderBy" = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#" />
								WHERE
									"navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position.navigationID#" />::uuid
									AND "pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].pathID#" />::uuid
									AND "pathID" IN (
										<!--- Make sure all paths are directly off the base path, including wildcard paths --->
										SELECT p."pathID"
										FROM "#variables.datasource.prefix#content"."path" p
										JOIN "#variables.datasource.prefix#content"."content" c
										ON p."contentID" = c."contentID"
											AND c."domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid
										WHERE LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%" />
											AND (
												LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%" />
												OR (
													LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/*" />
													AND LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%/*" />
												)
											)
									)
							</cfquery>
						<cfelse>
							<cfquery datasource="#variables.datasource.name#">
								INSERT INTO "#variables.datasource.prefix#content"."bPath2Navigation"
								(
									"pathID",
									"navigationID",
									"title",
									"groupBy",
									"orderBy"
								) VALUES (
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].pathID#" />::uuid,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#position.navigationID#" />::uuid,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].title#" />,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#position.paths[i].groupBy#" />,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" />
								)
							</cfquery>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cftransaction>
		
		<!--- After Position Event --->
		<cfset observer.afterPosition(variables.transport, arguments.path, arguments.positions) />
	</cffunction>
</cfcomponent>
