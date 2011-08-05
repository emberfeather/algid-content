<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
<cfscript>
	public boolean function inContent(required struct theApplication, required string targetPage) {
		var path = '';
		
		// Get the path to the base
		path = arguments.theApplication.managers.singleton.getApplication().getPath();
		path &= arguments.theApplication.managers.plugin.getContent().getPath();
		
		// Only pages in the root of path qualify
		return reFind('^' & path & '[a-zA-Z0-9-\.]*.cfm$', arguments.targetPage) GT 0;
	}
	
	public void function onApplicationStart(required struct theApplication) {
		var cacheManager = '';
		var caches = '';
		var navigation = '';
		var plugin = '';
		var storagePath = '';
		var temp = '';
		
		// Get the plugin
		plugin = arguments.theApplication.managers.plugin.getContent();
		
		// Create the navigation singleton
		navigation = arguments.theApplication.factories.transient.getNavigationForContent(arguments.theApplication.managers.singleton.getApplication().getDSUpdate(), arguments.theApplication.managers.singleton.getI18N());
		
		arguments.theApplication.managers.singleton.setContentNavigation(navigation);
		
		cacheManager = plugin.getCache();
		caches = plugin.getCaches();
		
		// Create the content cache
		if(caches.content != '') {
			temp = arguments.theApplication.factories.transient.getCacheContentForContent( caches.content );
			
			cacheManager.setContent(temp);
		}
		
		// Create the navigation cache
		if(caches.navigation != '') {
			temp = arguments.theApplication.factories.transient.getCacheNavigationForContent( caches.navigation );
			
			cacheManager.setNavigation(temp);
		}
	}
	
	public void function onRequestStart(required struct theApplication, required struct theSession, required struct theRequest, required string targetPage) {
		var app = '';
		var filter = '';
		var options = '';
		var plugin = '';
		var rewrite = '';
		var temp = '';
		var theUrl = '';
		
		// Only do the following if in the content area
		if (inContent( arguments.theApplication, arguments.targetPage )) {
			// Default base
			if ( !structKeyExists(url, '_base') ) {
				url['_base'] = '/';
			}
			
			// Create the URL object for all the content requests
			app = arguments.theApplication.managers.singleton.getApplication();
			plugin = arguments.theApplication.managers.plugin.getContent();
			
			arguments.theRequest.webRoot =  app.getPath();
			arguments.theRequest.requestRoot =  plugin.getPath();
			
			options = { start = arguments.theRequest.webRoot & arguments.theRequest.requestRoot };
			
			rewrite = plugin.getRewrite();
			
			if(rewrite.isEnabled) {
				options.rewriteBase = rewrite.base;
				
				theUrl = arguments.theApplication.factories.transient.getUrlRewrite(arguments.theUrl, options);
			} else {
				theUrl = arguments.theApplication.factories.transient.getUrl(arguments.theUrl, options);
			}
			
			arguments.theRequest.managers.singleton.setUrl( theUrl );
		}
	}
</cfscript>
	<!---
		Configures the database for v0.1.0
	--->
	<cffunction name="postgreSQL0_1_0" access="public" returntype="void" output="false">
		<cfset var i = '' />
		
		<!---
			SCHEMA
		--->
		
		<!--- Content Schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#content"
				AUTHORIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#content" IS 'Content Plugin Schema';
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."domain"
			(
				"domainID" uuid NOT NULL,
				"domain" character varying(150) not NULL,
				"createdOn" timestamp without time zone not NULL DEFAULT now(),
				"archivedOn" timestamp without time zone,
				CONSTRAINT "domain_domainID_PK" PRIMARY KEY ("domainID"),
				CONSTRAINT "domain_domain_U" UNIQUE (domain)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."domain" IS 'Domains being administered by the content plugin.';
		</cfquery>
		
		<!--- Theme Table --->
		<!--- Required for Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".theme
			(
				"themeID" uuid NOT NULL,
				theme character varying(50) not NULL,
				directory character varying(50) not NULL,
				levels smallint not NULL DEFAULT 1,
				"isPublic" boolean not NULL DEFAULT true,
				"archivedOn" timestamp without time zone,
				CONSTRAINT "theme_themeID_PK" PRIMARY KEY ("themeID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".theme OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".theme IS 'Themes in use with the content plugin.';
		</cfquery>
		
		<!--- Type Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."type"
			(
				"typeID" uuid NOT NULL,
				"type" character varying(50) not NULL,
				"archivedOn" timestamp without time zone,
				CONSTRAINT "type_PK" PRIMARY KEY ("typeID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."type" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."type" IS 'Type of content available in the content plugin.';
		</cfquery>
		
		<!--- Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".attribute
			(
				"attributeID" uuid NOT NULL,
				"themeID" uuid NOT NULL,
				attribute character varying(100) not NULL,
				"key" character varying(25) not NULL,
				"hasCustom" boolean not NULL DEFAULT true,
				CONSTRAINT "attribute_PK" PRIMARY KEY ("attributeID"),
				CONSTRAINT "attribute_themeID_FK" FOREIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "attribute_themeID_key_u" UNIQUE ("themeID", key)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".attribute OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".attribute IS 'Theme attributes for manipulating the display of the content.';
		</cfquery>
		
		<!--- Attribute Option Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."attributeOption"
			(
				"attributeOptionID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				label character varying(100) not NULL,
				"value" character varying(50) not NULL,
				CONSTRAINT "attributeOption_PK" PRIMARY KEY ("attributeOptionID"),
				CONSTRAINT "attributeOption_optionID_FK" FOREIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."attributeOption" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."attributeOption" IS 'Theme attribute options to allow the user to choose a predefined attribute value.';
		</cfquery>
		
		<!--- Content Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."content"
			(
				"contentID" uuid NOT NULL,
				"domainID" uuid NOT NULL,
				"typeID" uuid,
				title character varying(255) NOT NULL,
				"content" text NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				"updatedOn" timestamp without time zone NOT NULL DEFAULT now(),
				"expiresOn" timestamp without time zone,
				"archivedOn" timestamp without time zone,
				CONSTRAINT "content_content_PK" PRIMARY KEY ("contentID"),
				CONSTRAINT "content_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "content_typeID_FK" FOREIGN KEY ("typeID")
					REFERENCES "#variables.datasource.prefix#content"."type" ("typeID") MATCH SIMPLE
					ON UPDATE NO ACTION ON DELETE NO ACTION
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."content" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."content" IS 'Content for the content plugin.';
		</cfquery>
		
		<!--- Draft Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".draft
			(
				"contentID" uuid NOT NULL,
				draft text not NULL,
				"publishOn" timestamp without time zone,
				"createdOn" timestamp without time zone not NULL DEFAULT now(),
				"updatedOn" timestamp without time zone not NULL DEFAULT now(),
				CONSTRAINT "draft_PK" PRIMARY KEY ("contentID", "createdOn"),
				CONSTRAINT "draft_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".draft OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".draft IS 'Content drafts information for unpublished content.';
		</cfquery>
		
		<!--- Meta Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".meta
			(
				"metaID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				"name" character varying(35) not NULL,
				"value" text not NULL,
				CONSTRAINT "meta_PK" PRIMARY KEY ("metaID"),
				CONSTRAINT "meta_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE NO ACTION ON DELETE NO ACTION
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".meta OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".meta IS 'Meta information associated with the content.';
		</cfquery>
		
		<!--- Navigation Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".navigation
			(
				"navigationID" uuid NOT NULL,
				"level" smallint not NULL,
				navigation character varying(50) not NULL,
				"themeID" uuid NOT NULL,
				"allowGroups" boolean not NULL DEFAULT true,
				CONSTRAINT "navigation_PK" PRIMARY KEY ("navigationID"),
				CONSTRAINT "navigation_themeID_FK" FOREIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "navigation_themeID_level_navigation_u" UNIQUE ("themeID", navigation, level),
				CONSTRAINT navigation_max_level CHECK (level < 10),
				CONSTRAINT navigation_min_level CHECK (level > 0)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".navigation OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".navigation IS 'Theme Navigation availablility';
		</cfquery>
		
		<!--- Path Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".path
			(
				"pathID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				path character varying(300) not NULL DEFAULT '/'::character varying,
				title character varying(255) not NULL,
				"groupBy" character varying(100),
				"orderBy" integer not NULL DEFAULT 0,
				"isActive" bit(1) not NULL,
				"navigationID" uuid,
				"themeID" uuid,
				CONSTRAINT "path_pathID_PK" PRIMARY KEY ("pathID"),
				CONSTRAINT "path_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "path_navigationID_FK" FOREIGN KEY ("navigationID")
					REFERENCES "#variables.datasource.prefix#content".navigation ("navigationID") MATCH SIMPLE
					ON UPDATE RESTRICT ON DELETE RESTRICT,
				CONSTRAINT "path_themeID_FK" FOREIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE RESTRICT ON DELETE RESTRICT
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".path OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".path IS 'Paths for locating content.';
		</cfquery>
		
		<!--- Permalink Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".permalink
			(
				"permalinkID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				permalink character varying(100) not NULL,
				CONSTRAINT "permalink_permalinkID_PK" PRIMARY KEY ("permalinkID"),
				CONSTRAINT "permalink_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".permalink OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".permalink IS 'Permalink information for content.';
		</cfquery>
		
		<!--- Resource Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".resource
			(
				"resourceID" uuid NOT NULL,
				resource character varying(155) not NULL,
				file character varying(255) not NULL,
				"archivedOn" timestamp without time zone NULL,
				"createdOn" timestamp without time zone not NULL DEFAULT now(),
				"deprecatedOn" timestamp without time zone NULL,
				"isPublic" boolean not NULL DEFAULT false,
				CONSTRAINT "resource_resourceID_PK" PRIMARY KEY ("resourceID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".resource OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".resource IS 'Resources administered by the content plugin.';
		</cfquery>
		
		<!--- Host Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."host"
			(
				"hostID" uuid NOT NULL,
				"domainID" uuid NOT NULL,
				hostname character varying(255) not NULL,
				"isPrimary" boolean not NULL DEFAULT false,
				"hasSSL" boolean not NULL DEFAULT false,
				CONSTRAINT "host_PK" PRIMARY KEY ("hostID"),
				CONSTRAINT "host_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "host_hostname_U" UNIQUE (hostname)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."host" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."host" IS 'Hosts assigned to a domain.';
		</cfquery>
		
		<!--- Bridge: Content to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bContent2Attribute"
			(
				"contentID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				"attributeOptionID" uuid,
				"value" character varying(50),
				CONSTRAINT "bContent2Attribute_PK" PRIMARY KEY ("contentID", "attributeID"),
				CONSTRAINT "bContent2Attribute_attributeID_FK" FOREIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bContent2Attribute_attributeOptionID_FK" FOREIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bContent2Attribute_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bContent2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bContent2Attribute" IS 'Bridge for the content attributes.';
		</cfquery>
		
		<!--- Bridge: Content to Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bContent2Tag"
			(
				"contentID" uuid NOT NULL,
				"tagID" uuid NOT NULL,
				"createdOn" timestamp without time zone not NULL DEFAULT now(),
				CONSTRAINT "bContent2Tag_PK" PRIMARY KEY ("contentID", "tagID"),
				CONSTRAINT "bContent2Tag_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bContent2Tag_tagID_FK" FOREIGN KEY ("tagID")
					REFERENCES "#variables.datasource.prefix#tagger".tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bContent2Tag" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bContent2Tag" IS 'Bridge for attaching tags to content.';
		</cfquery>
		
		<!--- Bridge: Domain to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bDomain2Attribute"
			(
				"domainID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				"attributeOptionID" uuid,
				"value" character varying(50),
				CONSTRAINT "bDomain2Attribute_PK" PRIMARY KEY ("domainID", "attributeID"),
				CONSTRAINT "bDomain2Attribute_attributeID_FK" FOREIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Attribute_attributeOptionID_FK" FOREIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bDomain2Attribute_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bDomain2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bDomain2Attribute" IS 'Bridge for domain attributes.';
		</cfquery>
		
		<!--- Bridge: Domain to Tag to User Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User"
			(
				"domainID" uuid NOT NULL,
				"tagID" uuid NOT NULL,
				"userID" uuid NOT NULL,
				"createdOn" timestamp without time zone not NULL DEFAULT now(),
				CONSTRAINT "bDomain2Tag2User_PK" PRIMARY KEY ("domainID", "tagID", "userID"),
				CONSTRAINT "bDomain2Tag2User_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Tag2User_tagID_FK" FOREIGN KEY ("tagID")
					REFERENCES "#variables.datasource.prefix#tagger".tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Tag2User_userID_FK" FOREIGN KEY ("userID")
					REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User" IS 'Bridge for tying the domain to tag for a user.';
		</cfquery>
		
		<!--- Bridge: Path to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bPath2Attribute"
			(
				"pathID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				"attributeOptionID" uuid,
				"value" character varying(50),
				CONSTRAINT "bPath2Attribute_PK" PRIMARY KEY ("pathID", "attributeID"),
				CONSTRAINT "bPath2Attribute_attributeID_FK" FOREIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bPath2Attribute_attributeOption_FK" FOREIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bPath2Attribute_pathID_FK" FOREIGN KEY ("pathID")
					REFERENCES "#variables.datasource.prefix#content".path ("pathID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bPath2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bPath2Attribute" IS 'Bridge for the path attributes.';
		</cfquery>
		
		<!--- Bridge: Path to Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bPath2Tag"
			(
				"pathID" uuid NOT NULL,
				"tagID" uuid NOT NULL,
				"isRecursive" boolean not NULL DEFAULT false,
				"createdOn" timestamp without time zone not NULL DEFAULT now(),
				CONSTRAINT "bPath2Tag_PK" PRIMARY KEY ("pathID", "tagID"),
				CONSTRAINT "bPath2Tag_pathID_FK" FOREIGN KEY ("pathID")
					REFERENCES "#variables.datasource.prefix#content".path ("pathID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bPath2Tag_tagID_FK" FOREIGN KEY ("tagID")
					REFERENCES "#variables.datasource.prefix#tagger".tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bPath2Tag" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bPath2Tag" IS 'Bridge for attaching tags to paths.';
		</cfquery>
		
		<!--- Bridge: Resource to Content Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Content"
			(
				"resourceID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				CONSTRAINT "bResource2Content_PK" PRIMARY KEY ("resourceID", "contentID"),
				CONSTRAINT "bResource2Content_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Content_resourceID_FK" FOREIGN KEY ("resourceID")
					REFERENCES "#variables.datasource.prefix#content".resource ("resourceID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bResource2Content" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Content" IS 'Bridge for attaching resources to content.';
		</cfquery>
		
		<!--- Bridge: Resource to Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Domain"
			(
				"domainID" uuid NOT NULL,
				"resourceID" uuid NOT NULL,
				CONSTRAINT "bResource2Domain_PK" PRIMARY KEY ("resourceID", "domainID"),
				CONSTRAINT "bResource2Domain_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Domain_resourceID_FK" FOREIGN KEY ("resourceID")
					REFERENCES "#variables.datasource.prefix#content".resource ("resourceID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bResource2Domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Domain" IS 'Bridge for attaching resources to domains.';
		</cfquery>
		
		<!--- Bridge: Resource to Theme Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Theme"
			(
				"resourceID" uuid NOT NULL,
				"themeID" uuid NOT NULL,
				CONSTRAINT "bResource2Theme_PK" PRIMARY KEY ("resourceID", "themeID"),
				CONSTRAINT "bResource2Theme_resourceID_FK" FOREIGN KEY ("resourceID")
					REFERENCES "#variables.datasource.prefix#content".resource ("resourceID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Theme_themeID_FK" FOREIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bResource2Theme" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Theme" IS 'Bridge for attaching resources to themes.';
		</cfquery>
		
		<!--- Bridge: Theme to Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bTheme2Domain"
			(
				"themeID" uuid NOT NULL,
				"domainID" uuid NOT NULL,
				CONSTRAINT "bTheme2Domain_PK" PRIMARY KEY ("themeID", "domainID"),
				CONSTRAINT "bTheme2Domain_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bTheme2Domain_themeID_FK" FOREIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bTheme2Domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bTheme2Domain" IS 'Bridge for typing the theme to domains.';
		</cfquery>
		
		<!---
			DATA
		--->
		
		<!--- Content Type --->
		<cfloop list="HTML,Markdown,Confluence,Textile,MediaWiki,TracWiki,TWiki" index="i">
			<cfquery datasource="#variables.datasource.name#">
				INSERT INTO "#variables.datasource.prefix#content"."type"
				(
					"typeID",
					"type"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#" />::uuid,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#" />
				);
			</cfquery>
		</cfloop>
	</cffunction>
	
	<!---
		Configures the database for v0.1.2
	--->
	<cffunction name="postgreSQL0_1_2" access="public" returntype="void" output="false">
		<!---
			TABLES
		--->
		
		<!--- Path Table --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".path ADD COLUMN "template" character varying(50);
		</cfquery>
	</cffunction>
	
	<!---
		Configures the database for v0.1.3
	--->
	<cffunction name="postgreSQL0_1_3" access="public" returntype="void" output="false">
		<!---
			TABLES
		--->
		
		<!--- Bridge: Path to Navigation Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bPath2Navigation"
			(
				"pathID" uuid NOT NULL,
				"navigationID" uuid NOT NULL,
				title character varying(255) NOT NULL,
				"groupBy" character varying(100),
				"orderBy" integer NOT NULL DEFAULT 0,
				CONSTRAINT "bPath2Navigation_pkey" PRIMARY KEY ("pathID", "navigationID"),
				CONSTRAINT "bPath2Navigation_navigationID_fkey" FOREIGN KEY ("navigationID")
					REFERENCES "#variables.datasource.prefix#content".navigation ("navigationID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bPath2Navigation_pathID_fkey" FOREIGN KEY ("pathID")
					REFERENCES "#variables.datasource.prefix#content".path ("pathID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (
				OIDS=FALSE
			);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bPath2Navigation" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bPath2Navigation" IS 'Bridge for attaching navigations to paths.';
		</cfquery>
		
		<!--- Pull over existing navigation information --->
		<cfquery datasource="#variables.datasource.name#">
			INSERT INTO "#variables.datasource.prefix#content"."bPath2Navigation"
			(
				"pathID",
				"navigationID",
				title,
				"groupBy",
				"orderBy"
			)
			SELECT
				"pathID",
				"navigationID",
				title,
				"groupBy",
				"orderBy"
			FROM "#variables.datasource.prefix#content"."path"
			WHERE "navigationID" IS NOT NULL
		</cfquery>
		
		<!--- Remove old columns --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".path DROP COLUMN title;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".path DROP COLUMN "groupBy";
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".path DROP COLUMN "orderBy";
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".path DROP COLUMN "navigationID";
		</cfquery>
	</cffunction>
	
	<!---
		Configures the database for v0.1.13
	--->
	<cffunction name="postgreSQL0_1_13" access="public" returntype="void" output="false">
		<!---
			TABLES
		--->
		
		<!--- Remove Type --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."content" DROP COLUMN "typeID";;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			DROP TABLE "#variables.datasource.prefix#content"."type";
		</cfquery>
	</cffunction>
<cfscript>
	public void function update( required struct plugin, string installedVersion = '' ) {
		var versions = createObject('component', 'algid.inc.resource.utility.version').init();
		
		// Check for control of the main application index
		if(!fileExists('/root/index.cfm')) {
			fileWrite('/root/index.cfm', '<!--- This application is controlled by the content plugin --->' & chr(10) & '<cfinclude template="/plugins/content/inc/wrapper.cfm" />' & chr(10));
		}
		
		// fresh => 0.1.0
		if (versions.compareVersions(arguments.installedVersion, '0.1.0') lt 0) {
			switch (variables.datasource.type) {
			case 'PostgreSQL':
				postgreSQL0_1_0();
				
				break;
			default:
				throw(message="Database Type Not Supported", detail="The #variables.datasource.type# database type is not currently supported");
			}
		}
		
		// 0.1.2
		if (versions.compareVersions(arguments.installedVersion, '0.1.2') lt 0) {
			switch (variables.datasource.type) {
			case 'PostgreSQL':
				postgreSQL0_1_2();
				
				break;
			default:
				throw(message="Database Type Not Supported", detail="The #variables.datasource.type# database type is not currently supported");
			}
		}
		
		// 0.1.3
		if (versions.compareVersions(arguments.installedVersion, '0.1.3') lt 0) {
			switch (variables.datasource.type) {
			case 'PostgreSQL':
				postgreSQL0_1_3();
				
				break;
			default:
				throw(message="Database Type Not Supported", detail="The #variables.datasource.type# database type is not currently supported");
			}
		}
		
		// 0.1.3
		if (versions.compareVersions(arguments.installedVersion, '0.1.13') lt 0) {
			switch (variables.datasource.type) {
			case 'PostgreSQL':
				postgreSQL0_1_13();
				
				break;
			default:
				throw(message="Database Type Not Supported", detail="The #variables.datasource.type# database type is not currently supported");
			}
		}
	}
</cfscript>
	<!--- TODO Remove when Railo supports directoryCreate() --->
	<cffunction name="directoryCreate" access="public" returntype="void" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfdirectory action="create" directory="#arguments.path#" />
	</cffunction>
</cfcomponent>
