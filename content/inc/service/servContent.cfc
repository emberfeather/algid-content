<cfcomponent extends="algid.inc.resource.base.service" output="false">
<cfscript>
	public component function init( required struct transport ) {
		super.init(arguments.transport);
		
		variables.path = arguments.transport.theApplication.managers.singleton.getPathForContent();
		
		return this;
	}
</cfscript>
	<cffunction name="archiveContent" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user Permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.currUser, arguments.content) />
		
		<!--- TODO Archive the content --->
		
		<!--- TODO Clear the cache for archived content --->
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.currUser, arguments.content) />
	</cffunction>
<cfscript>
	public void function clearCache() {
		var contentCache = '';
		
		// Get the cache for the content
		contentCache = variables.transport.theApplication.managers.plugin.getContent().getCache().getContent();
		
		// Clear the cache
		contentCache.clear();
	}
	
	public void function deleteCacheKey( required string key ) {
		var contentCache = '';
		
		// Get the cache for the content
		contentCache = variables.transport.theApplication.managers.plugin.getContent().getCache().getContent();
		
		// Delete from the cache
		contentCache.delete( arguments.key );
	}
	
	public array function getCacheAllIds() {
		var contentCache = '';
		
		// Get the cache for the content
		contentCache = variables.transport.theApplication.managers.plugin.getContent().getCache().getContent();
		
		// Clear the cache
		return contentCache.getAllIds();
	}
</cfscript>
	<cffunction name="getContent" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="contentID" type="string" required="true" />
		
		<cfset var content = '' />
		<cfset var i = '' />
		<cfset var modelSerial = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var type = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<cfset content = getModel('content', 'content') />
		
		<cfif arguments.contentID neq ''>
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "contentID", "domainID", "typeID", "title", "content", "createdOn", "updatedOn", "expiresOn", "archivedOn"
				FROM "#variables.datasource.prefix#content"."content"
				WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" null="#arguments.contentID eq ''#" />::uuid
				
				<!--- TODO Check for user connection --->
			</cfquery>
			
			<cfif results.recordCount>
				<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
				
				<cfset modelSerial.deserialize(results, content) />
				
				<cfset type = getModel('content', 'type') />
				
				<cfif content.getTypeID() neq ''>
					<!--- Retrieve the content type object --->
					<cfquery name="results" datasource="#variables.datasource.name#">
						SELECT "typeID", "type"
						FROM "#variables.datasource.prefix#content"."type"
						WHERE "typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#content.getTypeID()#" />::uuid
					</cfquery>
					
					<cfset modelSerial.deserialize(results, type) />
				</cfif>
				
				<cfset content.setType(type) />
			</cfif>
		</cfif>
		
		<!--- After Read Event --->
		<cfset observer.afterRead(variables.transport, arguments.currUser, content) />
		
		<cfreturn content />
	</cffunction>
	
	<cffunction name="getContents" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				domain = variables.transport.theCgi.server_name,
				orderBy = 'title',
				orderSort = 'asc'
			} />
		<cfset var i = '' />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT DISTINCT c."contentID", p."path", bpn."title" AS navTitle, t."type", c."title", c."createdOn", c."updatedOn", c."archivedOn", c."content"
			FROM "#variables.datasource.prefix#content"."content" c
			LEFT JOIN "#variables.datasource.prefix#content"."path" p
				ON c."contentID" = p."contentID"
			LEFT JOIN "#variables.datasource.prefix#content"."bPath2Navigation" bpn
				ON p."pathID" = bpn."pathID"
			LEFT JOIN "#variables.datasource.prefix#content"."type" t
				ON c."typeID" = t."typeID"
			JOIN "#variables.datasource.prefix#content"."host" h
				ON c."domainID" = h."domainID"
					AND h."hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					bpn."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR c."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR bpn."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<!--- Check if we want to find a key in the path --->
			<cfif structKeyExists(arguments.filter, 'pathKey')>
				AND (
					p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%/#arguments.filter.pathKey#" />
					OR p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%/#arguments.filter.pathKey#/%" />
					OR p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.pathKey#/%" />
				)
			</cfif>
			
			<!--- Check for path specific filters --->
			<cfif structKeyExists(arguments.filter, 'keyAlongPathOrPath')>
				<!--- Find a key that is along the path --->
				<cfparam name="arguments.filter.path" default="/" />
				
				<!--- Match a specific path or look for a key along the path --->
				AND (
					LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.clean(arguments.filter.path))#" />
					OR LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.createList(variables.path.clean(arguments.filter.path), arguments.filter.keyAlongPathOrPath))#" list="true" />)
				)
			<cfelseif structKeyExists(arguments.filter, 'keyAlongPath')>
				<!--- Find a key that is along the path --->
				<cfparam name="arguments.filter.path" default="/" />
				
				AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.createList(variables.path.clean(arguments.filter.path), arguments.filter.keyAlongPath))#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'alongPath')>
				<!--- Find any content along the path --->
				AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.createList(variables.path.clean(arguments.filter.alongPath)))#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'searchPath')>
				<!--- Match a specific path --->
				AND LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.searchPath)#%" />
			<cfelseif structKeyExists(arguments.filter, 'path')>
				<!--- Match a specific path --->
				AND LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.clean(arguments.filter.path))#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'type') and arguments.filter.type neq ''>
				AND c."typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.type#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				and c."archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfcase value="updatedOn">
					c."updatedOn" #arguments.filter.orderSort#,
					c."title" ASC
				</cfcase>
				<cfcase value="navTitle">
					bpn."title" #arguments.filter.orderSort#,
					c."title" #arguments.filter.orderSort#
				</cfcase>
				<cfcase value="path">
					p."path" #arguments.filter.orderSort#
				</cfcase>
				<cfdefaultcase>
					p."path" #arguments.filter.orderSort#,
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
	
	<cffunction name="publishContent" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<!--- TODO Check for user permission --->
		
		<!--- Before Publish Event --->
		<cfset observer.beforePublish(variables.transport, arguments.currUser, arguments.content) />
		
		<!--- TODO Publish the content --->
		
		<!--- After Publish Event --->
		<cfset observer.afterPublish(variables.transport, arguments.currUser, arguments.content) />
	</cffunction>
<cfscript>
	public component function retrieveContent( struct options = {} ) {
		var content = '';
		var contentCache = '';
		var filter = {
			domain = transport.theCgi.server_name,
			keyAlongPathOrPath = ['*'],
			orderBy = 'path',
			orderSort = 'desc',
			path = variables.transport.theRequest.managers.singleton.getUrl().search('_base')
		};
		var paths = '';
		var servPath = '';
		
		servPath = getService('content', 'path');
		
		filter = extend(filter, arguments.options);
		
		// Use the plugin cache to pull the content from the cache first
		contentCache = variables.transport.theApplication.managers.plugin.getContent().getCache().getContent();
		
		try {
			// Check for cached version
			if( contentCache.has( filter.domain & filter.path ) ) {
				content = contentCache.get( filter.domain & filter.path );
			} else {
				// The content is not cached, retrieve it
				paths = servPath.getPaths( filter );
				
				if (paths.recordCount gt 0) {
					content = getContent( transport.theSession.managers.singleton.getUser(), paths.contentID.toString() );
					
					// Set the template
					content.setTemplate(paths.template);
					
					// Store the original path requested
					content.setPathExtra(filter.path, paths.path);
					
					// Trigger the before show event
					transport.theApplication.managers.plugin.getContent().getObserver().getContent().beforeDisplay(transport, content);
					
					// Check if the content should be cached
					if (content.getDoCaching()) {
						contentCache.put(filter.domain & filter.path, content);
					}
				} else {
					getPageContext().getResponse().setStatus(404, 'Content not found');
					
					filter.keyAlongPath = '404';
					
					paths = servPath.getPaths( filter );
					
					if( paths.recordCount gt 0) {
						// Use the cache for the error page
						if( contentCache.has( filter.domain & paths.path )) {
							content = contentCache.get( filter.domain & paths.path );
						} else {
							content = getContent( transport.theSession.managers.singleton.getUser(), paths.contentID.toString() );
							
							// Set the template
							content.setTemplate(paths.template);
							
							// Store the original path requested
							content.setPathExtra(filter.path, paths.path);
							
							// Trigger the before show event
							transport.theApplication.managers.plugin.getContent().getObserver().getContent().beforeDisplay(transport, content);
							
							// Check if the content should be cached
							if( content.getDoCaching()) {
								contentCache.put(filter.domain & paths.path, content);
							}
						}
					} else {
						content = getContent( transport.theSession.managers.singleton.getUser(), '' );
						
						// Page not found and no 404 page along the path
						content.setTitle('404 Not Found');
						content.setContent('404... content not found!');
						content.setTemplate('index');
					}
					
					content.setIsError(true);
				}
			}
		} catch( any err ) {
			getPageContext().getResponse().setStatus(500, 'Internal Server Error');
			
			// Track/dump the exception
			if (transport.theApplication.managers.singleton.getApplication().isDevelopment() ) {
				// Dump out the error
				writeDump(err);
				
				abort;
			} else {
				try {
					errorLogger = transport.theApplication.managers.singleton.getErrorLog();
					
					errorLogger.log(err);
				} catch (any err) {
					// Failed to log error, send report of unlogged error
					
					// TODO Send Unlogged Error
				}
			}
			
			filter.keyAlongPath = '500';
			
			// The content is not cached, retrieve it
			paths = servPath.getPaths( filter );
			
			if (paths.recordCount gt 0) {
				// Use the cache for the error page
				if ( contentCache.has( filter.domain & paths.path ) ) {
					content = contentCache.get( filter.domain & paths.path );
				} else {
					content = getContent( transport.theSession.managers.singleton.getUser(), paths.contentID.toString() );
					
					// Set the template
					content.setTemplate(paths.template);
					
					// Store the original path requested
					content.setPathExtra(filter.path, paths.path);
					
					// Trigger the before show event
					transport.theApplication.managers.plugin.getContent().getObserver().getContent().beforeDisplay(transport, content);
					
					// Check if the content should be cached
					if (content.getDoCaching()) {
						contentCache.put(filter.domain & paths.path, content);
					}
				}
			} else {
				content = getContent( transport.theSession.managers.singleton.getUser(), '' );
				
				// Page not found and no 500 page along the path
				content.setTitle('500 Server Error');
				content.setContent('500... Internal server error!');
				content.setTemplate('index');
			}
			
			content.setIsError(true);
		}
		
		variables.transport.theRequest.managers.singleton.setContent(content);
		
		return content;
	}
</cfscript>
	<cffunction name="setContent" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Retrieve the paths from the content --->
		<cfset paths = arguments.content.getPaths() />
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.content) />
		
		<cfif arguments.content.getContentID() neq ''>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.currUser, arguments.content) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."content"
					SET
						"typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getTypeID()#" null="#arguments.content.getTypeID() eq ''#" />::uuid,
						"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getDomainID()#" />::uuid,
						"title" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getTitle()#" />,
						"content" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.content.getContent()#" />,
						"updatedOn" = now(),
						"archivedOn" = NULL
					WHERE
						"contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getContentID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.content) />
		<cfelse>
			<!--- Before Create Event --->
			<cfset observer.beforeCreate(variables.transport, arguments.currUser, arguments.content) />
			
			<!--- Insert as a new domain --->
			<!--- Create the new ID --->
			<cfset arguments.content.setContentID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."content" (
						"contentID",
						"domainID",
						"title",
						"content", 
						"updatedOn"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getContentID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getDomainID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getTitle()#" />,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.content.getContent()#" />,
						now()
					)
				</cfquery>
			</cftransaction>
			
			<!--- After Create Event --->
			<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.content) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.content) />
	</cffunction>
</cfcomponent>
