<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveDomain" access="public" returntype="void" output="false">
		<cfargument name="domain" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'domain') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.domain) />
		
		<!--- Archive the domain --->
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				UPDATE "#variables.datasource.prefix#content"."domain"
				SET
					"archivedOn" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				WHERE
					"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid
			</cfquery>
		</cftransaction>
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.domain) />
	</cffunction>
	
	<cffunction name="deleteHosts" access="public" returntype="void" output="false">
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var i = '' />
		<cfset var id = '' />
		<cfset var observer = '' />
		
		<cfparam name="arguments.filter.domainID" default="" />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'host') />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- Before Delete Bulk Event --->
		<cfset observer.beforeDeleteBulk(variables.transport, arguments.filter) />
		
		<!--- Delete the host --->
		<cfquery datasource="#variables.datasource.name#">
			DELETE
			FROM "#variables.datasource.prefix#content"."host"
			WHERE "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domainID#" null="#arguments.filter.domainID eq ''#" />::uuid
			
			<cfif structKeyExists(arguments.filter, 'in')>
				AND "hostID" IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.in)#" index="i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.in[i]#" null="#arguments.filter.in[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.in)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notIn')>
				AND "hostID" NOT IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.notIn)#" index="i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.notIn[i]#" null="#arguments.filter.notIn[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.notIn)>,</cfif>
					</cfloop>
				)
			</cfif>
		</cfquery>
		
		<!--- After Delete Bulk Event --->
		<cfset observer.afterDeleteBulk(variables.transport, arguments.filter) />
	</cffunction>
	
	<cffunction name="getDomain" access="public" returntype="component" output="false">
		<cfargument name="domainID" type="string" required="true" />
		
		<cfset var domain = '' />
		<cfset var host = '' />
		<cfset var i = '' />
		<cfset var modelSerial = '' />
		<cfset var results = '' />
		
		<cfset domain = getModel('content', 'domain') />
		
		<cfif not len(arguments.domainID)>
			<cfreturn domain />
		</cfif>
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "domainID", "domain", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domainID#" null="#arguments.domainID eq ''#" />::uuid
		</cfquery>
		
		<cfif results.recordCount>
			<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
			
			<cfset modelSerial.deserialize(results, domain) />
			
			<!--- Retrieve the domain hosts --->
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "hostID", "domainID", "hostname", "hasSSL"
				FROM "#variables.datasource.prefix#content"."host"
				WHERE "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domainID#" />::uuid
				ORDER BY "host" ASC
			</cfquery>
			
			<cfloop query="results">
				<cfset host = getModel('content', 'host') />
				
				<cfloop list="#structKeyList(results)#" index="i">
					<cfinvoke component="#host#" method="set#i#">
						<cfinvokeargument name="value" value="#results[i]#" />
					</cfinvoke>
				</cfloop>
				
				<cfset domain.addHosts(host) />
			</cfloop>
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
			SELECT DISTINCT d."domainID", d."domain", d."createdOn", d."archivedOn"
			FROM "#variables.datasource.prefix#content"."domain" d
			LEFT JOIN "#variables.datasource.prefix#content"."host" h
				ON d."domainID" = h."domainID"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and (
					d."domain" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					or h."hostname" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'host') and arguments.filter.host neq ''>
				and h."hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.host#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				and d."archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					d."domain" #arguments.filter.orderSort#
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
	
	<cffunction name="getDomainStats" access="public" returntype="struct" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset local.defaultDate = now() />
		
		<cfset arguments.filter = extend({
			startOn = dateAdd("m", -1, local.defaultDate),
			endOn = local.defaultDate
		}, arguments.filter) />
		
		<cfset local.results = {} />
		
		<!--- New --->
		<cfquery name="local.results.new" datasource="#variables.datasource.name#">
			SELECT COUNT("domainID") AS total
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE 1=1
				AND "archivedOn" IS NULL
				AND "createdOn" >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.startOn#" />
				AND "createdOn" < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.endOn#" />
		</cfquery>
		
		<!--- Archived --->
		<cfquery name="local.results.archived" datasource="#variables.datasource.name#">
			SELECT COUNT("domainID") AS total
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE 1=1
				AND "archivedOn" IS NOT NULL
				AND "archivedOn" >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.startOn#" />
				AND "archivedOn" < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.endOn#" />
		</cfquery>
		
		<cfreturn local.results />
	</cffunction>
	
	<cffunction name="getHost" access="public" returntype="component" output="false">
		<cfargument name="hostID" type="string" required="true" />
		
		<cfset var host = '' />
		<cfset var modelSerial = '' />
		<cfset var results = '' />
		
		<cfset host = getModel('content', 'host') />
		
		<cfif not len(arguments.hostID)>
			<cfreturn host />
		</cfif>
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "hostID", "domainID", "hostname", "isPrimary", "hasSSL"
			FROM "#variables.datasource.prefix#content"."host"
			WHERE "hostID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hostID#" />::uuid
		</cfquery>
		
		<cfif results.recordCount>
			<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
			
			<cfset modelSerial.deserialize(results, host) />
		</cfif>
		
		<cfreturn host />
	</cffunction>
	
	<cffunction name="getHosts" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				orderBy = 'hostname',
				orderSort = 'asc'
			} />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "hostID", "domainID", "hostname", "isPrimary", "hasSSL"
			FROM "#variables.datasource.prefix#content"."host"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'domainID')>
				and "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domainID#" null="#arguments.filter.domainID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'hostname') and arguments.filter.hostname neq ''>
				and "hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.hostname#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and "hostname" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"hostname" #arguments.filter.orderSort#
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
	
	<cffunction name="getPrimaryHostname" access="public" returntype="string" output="false">
		<cfargument name="hostname" type="string" required="true" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#" cachedwithin="#createTimeSpan(0, 1, 0, 0)#">
			SELECT "hostname"
			FROM "#variables.datasource.prefix#content"."host"
			WHERE "isPrimary" = <cfqueryparam cfsqltype="cf_sql_bit" value="true" />::boolean
				AND "domainID" IN (
					SELECT "domainID"
					FROM "#variables.datasource.prefix#content"."host"
					WHERE "hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hostname#" />
				)
			ORDER BY "hostname" ASC
		</cfquery>
		
		<cfif results.recordCount gt 0>
			<cfreturn results.hostname />
		</cfif>
		
		<cfreturn arguments.hostname />
	</cffunction>
	
	<cffunction name="setDomain" access="public" returntype="void" output="false">
		<cfargument name="domain" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'domain') />
		
		<cfset validate__model(arguments.domain) />
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.domain) />
		
		<cfif arguments.domain.getDomainID() eq ''>
			<!--- Check for archived domain --->
			<cfquery datasource="#variables.datasource.name#" name="results">
				SELECT "domainID", "domain", "archivedOn"
				FROM "#variables.datasource.prefix#content"."domain"
				WHERE
					"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
			</cfquery>
			
			<!--- Check if we found an existing domain --->
			<cfif results.recordCount gt 0>
				<cfif results.archivedOn eq ''>
					<!--- Duplicate domain --->
					<cfthrow type="validation" message="Domain name already in use" detail="The '#arguments.domain.getDomain()#' domain already exists." />
				<cfelse>
					<cfset arguments.domain.setDomainID(results.domainID.toString()) />
					
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
					
					<!--- After Update Event --->
					<cfset observer.afterUnarchive(variables.transport, arguments.domain) />
				</cfif>
			<cfelse>
				<!--- Insert as a new domain --->
				<!--- Create the new ID --->
				<cfset arguments.domain.setDomainID( createUUID() ) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#content"."domain"
						(
							"domainID",
							"domain"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
						)
					</cfquery>
				</cftransaction>
				
				<!--- After Create Event --->
				<cfset observer.afterCreate(variables.transport, arguments.domain) />
			</cfif>
		<cfelse>
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					UPDATE "#variables.datasource.prefix#content"."domain"
					SET
						"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />,
						"archivedOn" = NULL
					WHERE
						"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.domain) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.domain) />
	</cffunction>
	
	<cffunction name="setHosts" access="public" returntype="void" output="false">
		<cfargument name="hosts" type="array" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var host = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'host') />
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.hosts) />
		
		<cfloop array="#arguments.hosts#" index="host">
			<cfset validate__model(host) />
			
			<cfif host.getHostID() eq ''>
				<!--- Check for in use hostname --->
				<cfquery datasource="#variables.datasource.name#" name="results">
					SELECT "hostname"
					FROM "#variables.datasource.prefix#content"."host"
					WHERE
						"hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostname()#" />
				</cfquery>
				
				<!--- Check if we found an existing hostname --->
				<cfif results.recordCount gt 0>
					<!--- Duplicate hostname --->
					<cfthrow type="validation" message="Hostname '#host.getHostname()#' already in use" detail="The '#host.getHostname()#' hostname already exists." />
				<cfelse>
					<!--- Insert as a new hostname --->
					<!--- Create the new ID --->
					<cfset host.setHostID( createUUID() ) />
					
					<!--- Before Create Event --->
					<cfset observer.beforeCreate(variables.transport, host) />
					
					<cftransaction>
						<cfquery datasource="#variables.datasource.name#" result="results">
							INSERT INTO "#variables.datasource.prefix#content"."host"
							(
								"hostID",
								"domainID",
								"hostname",
								"isPrimary",
								"hasSSL"
							) VALUES (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostID()#" />::uuid,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getDomainID()#" />::uuid,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostname()#" />,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#host.getIsPrimary()#" />::boolean,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#host.getHasSSL()#" />::boolean
							)
						</cfquery>
					</cftransaction>
					
					<!--- After Create Event --->
					<cfset observer.afterCreate(variables.transport, host) />
				</cfif>
			<cfelse>
				<!--- Before Update Event --->
				<cfset observer.beforeUpdate(variables.transport, host) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						UPDATE "#variables.datasource.prefix#content"."host"
						SET
							"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getDomainID()#" />::uuid,
							"hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostname()#" />,
							"isPrimary" = <cfqueryparam cfsqltype="cf_sql_bit" value="#host.getIsPrimary()#" />::boolean,
							"hasSSL" = <cfqueryparam cfsqltype="cf_sql_bit" value="#host.getHasSSL()#" />::boolean
						WHERE
							"hostID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostID()#" />::uuid
					</cfquery>
				</cftransaction>
				
				<!--- After Update Event --->
				<cfset observer.afterUpdate(variables.transport, host) />
			</cfif>
		</cfloop>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.hosts) />
	</cffunction>
</cfcomponent>
