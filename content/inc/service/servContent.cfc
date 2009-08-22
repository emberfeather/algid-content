<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getContents" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				orderBy = ''
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
			WHERE 1=1
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					c."title" DESC
				</cfdefaultcase>
			</cfswitch>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>