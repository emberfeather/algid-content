<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveDomain" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="domain" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user permissions --->
		
		<!--- Archive the domain --->
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				UPDATE "#variables.datasource.prefix#content"."domain"
				SET
					"archivedOn" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				WHERE
					"domainID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.domain.getDomainID()#" />
			</cfquery>
		</cftransaction>
		
		<cfset eventLog.logEvent('content', 'domainArchive', 'Archived the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID()) />
	</cffunction>
	
	<cffunction name="getDomain" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="domainID" type="numeric" required="true" />
		
		<cfset var domain = '' />
		<cfset var i18n = '' />
		<cfset var result = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfset domain = variables.transport.theApplication.factories.transient.getModDomainForContent( i18n, variables.transport.theSession.managers.singleton.getSession().getLocale() ) />
		
		<cfquery name="result" datasource="#variables.datasource.name#">
			SELECT "domainID", "domain", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE "domainID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.domainID#" />
		</cfquery>
		
		<cfif result.recordCount>
			<cfset domain.deserialize(result) />
		</cfif>
		
		<cfreturn domain />
	</cffunction>
	
	<cffunction name="getDomains" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				isArchived = false,
				orderBy = 'domain',
				orderSort = 'asc'
			} />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "domainID", "domain", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and (
					"domain" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				and "archivedOn" IS <cfif arguments.filter.isArchived>not</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"domain" #arguments.filter.orderSort#
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
	
	<cffunction name="setDomain" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="domain" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user permissions --->
		
		<cfif arguments.domain.getDomainID()>
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					UPDATE "#variables.datasource.prefix#content"."domain"
					SET
						"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />,
						"archivedOn" = NULL
					WHERE
						"domainID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.domain.getDomainID()#" />
				</cfquery>
			</cftransaction>
			
			<cfset eventLog.logEvent('content', 'domainUpdate', 'Updated the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID()) />
		<cfelse>
			<!--- Check for archived domain --->
			<cfquery datasource="#variables.datasource.name#" name="results">
				SELECT "domain"
				FROM "#variables.datasource.prefix#content"."domain"
				WHERE
					"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
					and "archivedOn" IS not NULL
			</cfquery>
			
			<!--- Check if we found an existing domain --->
			<cfif results.recordCount gt 0>
				<!--- Unarchive the domain --->
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						UPDATE "#variables.datasource.prefix#content"."domain"
						SET
							"archivedOn" = NULL
						WHERE
							"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
					</cfquery>
				</cftransaction>
				
				<cfset eventLog.logEvent('content', 'domainCreate', 'Unarchived the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID()) />
			<cfelse>
				<!--- Insert as a new domain --->
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#content"."domain"
						(
							"domain"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
						)
					</cfquery>
					
					<cfif structKeyExists(results, 'generatedKey')>
						<cfset domain.setDomainID(listGetAt(results.generatedKey, 1)) />
					<cfelse>
						<cfquery name="results" datasource="#variables.datasource.name#">
							SELECT MAX("domainID") AS newID
							FROM "#variables.datasource.prefix#content"."domain"
							WHERE "domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
						</cfquery>
						
						<cfset domain.setDomainID(results.newID) />
					</cfif>
				</cftransaction>
				
				<cfset eventLog.logEvent('content', 'domainCreate', 'Created the ''' & arguments.domain.getDomain() & ''' domain.', arguments.currUser.getUserID(), arguments.domain.getDomainID()) />
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>