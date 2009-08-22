<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getContents" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				domain = CGI.SERVER_NAME,
				orderBy = 'title',
				orderSort = 'asc'
			} />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT p."path", p."title" AS navTitle, t."type", c."title", c."createdOn", c."updatedBy", c."updatedOn", c."archivedOn"
			FROM "#variables.datasource.prefix#content"."content" AS c
			LEFT JOIN "#variables.datasource.prefix#content"."path" AS p
				ON c."contentID" = p."contentID"
			JOIN "#variables.datasource.prefix#content"."type" AS t
				ON c."typeID" = t."typeID"
			JOIN "#variables.datasource.prefix#content"."domain" AS d
				ON c."domainID" = d."domainID"
					AND d."domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
			WHERE 1=1
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfcase value="updatedOn">
					p."path" #arguments.filter.orderSort#
				</cfcase>
				<cfcase value="updatedOn">
					c."updatedOn" #arguments.filter.orderSort#,
					c."title" ASC
				</cfcase>
				<cfdefaultcase>
					c."title" #arguments.filter.orderSort#
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
</cfcomponent>